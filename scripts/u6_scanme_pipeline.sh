#!/usr/bin/env bash
set -euo pipefail

###############################################################################
# Unit 6 — Footprinting, Reconnaissance, and Scanning
# Repo-layout pipeline (scripts/ + runs/)
# Target locked to: scanme.nmap.org (authorized Nmap test host)
###############################################################################

TARGET_DEFAULT="scanme.nmap.org"
TARGET="${1:-$TARGET_DEFAULT}"

# Safety guard
if [[ "$TARGET" != "$TARGET_DEFAULT" ]]; then
  echo "[!] Safety guard: This script is intended ONLY for $TARGET_DEFAULT"
  echo "    Edit TARGET_DEFAULT if you have explicit authorization."
  exit 1
fi

TS="$(date +"%Y-%m-%d_%H%M%S")"
RUNS_DIR="runs"
OUTDIR="${RUNS_DIR}/${TS}_${TARGET}"

mkdir -p "$OUTDIR"

echo "[+] Run directory created:"
echo "    $OUTDIR"

###############################################################################
# Artifact paths
###############################################################################
REPORT="$OUTDIR/report.md"

WHOIS_DOMAIN="$OUTDIR/whois_domain.txt"
WHOIS_IP="$OUTDIR/whois_ip.txt"

NSLOOKUP_OUT="$OUTDIR/nslookup.txt"
DIG_OUT="$OUTDIR/dig.txt"
REVERSE_DNS_OUT="$OUTDIR/reverse_dns.txt"

DNSRECON_OUT="$OUTDIR/dnsrecon.txt"

NMAP_TOP="$OUTDIR/nmap_top1000.txt"
NMAP_SERVICE="$OUTDIR/nmap_service_scan.txt"
NMAP_GREP="$OUTDIR/nmap_service_scan.gnmap"
NMAP_XML="$OUTDIR/nmap_service_scan.xml"

PORTS_TABLE="$OUTDIR/open_ports_table.md"
RISK_TABLE="$OUTDIR/risk_ratings_table.md"

###############################################################################
# Dependency checks
###############################################################################
need_cmd() {
  command -v "$1" >/dev/null 2>&1 || {
    echo "[!] Missing dependency: $1"
    echo "    macOS: brew install $2"
    echo "    Debian/Kali: sudo apt update && sudo apt install -y $2"
    exit 1
  }
}


need_cmd dig "dnsutils"
need_cmd nslookup "dnsutils"
need_cmd host "dnsutils"
need_cmd whois "whois"
DNSRECON_CMD=""

if command -v dnsrecon >/dev/null 2>&1; then
  DNSRECON_CMD="dnsrecon"
elif python3 -m dnsrecon -h >/dev/null 2>&1; then
  DNSRECON_CMD="python3 -m dnsrecon"
else
  echo "[!] dnsrecon not found (brew does not provide it on macOS)"
  echo "    Install with: python3 -m pip install dnsrecon"
  exit 1
fi

need_cmd nmap "nmap"

###############################################################################
# Resolve IP
###############################################################################
echo "[+] Resolving IP address..."
IP="$(dig +short "$TARGET" | head -n 1 || true)"

if [[ -z "$IP" ]]; then
  echo "[!] Failed to resolve IP for $TARGET"
  exit 1
fi

echo "[+] Resolved IP: $IP"

###############################################################################
# 1) DNS Reconnaissance
###############################################################################
echo "[+] Running nslookup..."
nslookup "$TARGET" | tee "$NSLOOKUP_OUT" >/dev/null

echo "[+] Running dig (A + NS records)..."
{
  echo "### dig A $TARGET"
  dig "$TARGET" A
  echo
  echo "### dig NS $TARGET"
  dig "$TARGET" NS
} | tee "$DIG_OUT" >/dev/null

echo "[+] Reverse DNS lookup..."
host "$IP" | tee "$REVERSE_DNS_OUT" >/dev/null || true

###############################################################################
# 2) WHOIS
###############################################################################
echo "[+] WHOIS lookup (domain)..."
whois "$TARGET" | tee "$WHOIS_DOMAIN" >/dev/null || true

echo "[+] WHOIS lookup (IP)..."
whois "$IP" | tee "$WHOIS_IP" >/dev/null || true

###############################################################################
# 3) Enumeration (DNS / Subdomains)
###############################################################################
echo "[+] Running dnsrecon..."
$DNSRECON_CMD -d "$TARGET" -a | tee "$DNSRECON_OUT" >/dev/null || true


###############################################################################
# 4) Nmap Scanning
###############################################################################
echo "[+] Nmap stage 1 — top 1000 ports..."
nmap --top-ports 1000 --open -sT "$TARGET" -oN "$NMAP_TOP" >/dev/null

echo "[+] Nmap stage 2 — service & default scripts..."
nmap -sT -sV -sC --open \
  -oN "$NMAP_SERVICE" \
  -oG "$NMAP_GREP" \
  -oX "$NMAP_XML" \
  "$TARGET" >/dev/null

###############################################################################
# 5) Open Ports Table
###############################################################################
echo "[+] Building open ports table..."
awk '
  BEGIN {
    print "| Port | Proto | State | Service | Version / Notes |"
    print "|---:|:---:|:---:|:---|:---|"
  }
  /^[0-9]+\/tcp|^[0-9]+\/udp/ {
    split($1,a,"/")
    port=a[1]; proto=a[2]
    state=$2; service=$3
    version=""
    for (i=4;i<=NF;i++) version=version $i (i==NF?"":" ")
    if (version=="") version="(not shown)"
    print "| " port " | " proto " | " state " | " service " | " version " |"
  }
' "$NMAP_SERVICE" > "$PORTS_TABLE"

###############################################################################
# 6) Risk Ratings Table (Scaffold)
###############################################################################
echo "[+] Building risk ratings scaffold..."
awk '
  BEGIN {
    print "| Port | Service | Likelihood (1–5) | Impact (1–5) | Score | Rating | Rationale |"
    print "|---:|:---|:---:|:---:|:---:|:---:|:---|"
  }
  /^[0-9]+\/tcp|^[0-9]+\/udp/ {
    split($1,a,"/")
    port=a[1]; service=$3
    like="3"; impact="3"; score="9"; rating="MED"
    rationale="(update after review)"
    print "| " port " | " service " | " like " | " impact " | " score " | " rating " | " rationale " |"
  }
' "$NMAP_SERVICE" > "$RISK_TABLE"

###############################################################################
# 7) Generate report.md
###############################################################################
echo "[+] Generating report.md..."

cat > "$REPORT" <<EOF
# Unit 6 — Footprinting, Reconnaissance, and Scanning

**Target:** \`$TARGET\`  
**Resolved IP:** \`$IP\`  
**Run Timestamp:** \`$TS\`

> Authorized assessment of an intentionally exposed Nmap test host.  
> No exploitation performed.

---

## Executive Summary
A structured footprinting → reconnaissance → scanning workflow was executed to identify externally exposed services and assess high-level risk themes. All findings are supported by reproducible command output.

---

## 1) Footprinting (OSINT)
### Google Dorks (Manual)
- site:$TARGET
- site:nmap.org "$TARGET"
- "$TARGET" filetype:pdf
- "$TARGET" "password"

**Findings:**
- (Add manual notes here)

---

## 2) DNS Reconnaissance
Artifacts:
- nslookup.txt
- dig.txt
- reverse_dns.txt

---

## 3) WHOIS
Artifacts:
- whois_domain.txt
- whois_ip.txt

---

## 4) Enumeration
Artifacts:
- dnsrecon.txt

---

## 5) Network Scanning
Artifacts:
- nmap_top1000.txt
- nmap_service_scan.txt
- nmap_service_scan.gnmap
- nmap_service_scan.xml

### Open Ports Summary
EOF

cat "$PORTS_TABLE" >> "$REPORT"

cat >> "$REPORT" <<EOF

---

## 6) Risk Ratings
**Method:** Likelihood × Impact = Score

EOF

cat "$RISK_TABLE" >> "$REPORT"

cat >> "$REPORT" <<'EOF'

---

## 7) Security Analysis
(Provide concise per-port analysis: purpose, risk, and defensive posture.)

---

## 8) Mitigation Recommendations
- Minimize exposed services
- Enforce access controls and allowlisting
- Patch externally reachable software
- Harden authentication (keys, MFA, rate limits)
- Monitor and alert on anomalous activity

---

## 9) Limitations
- Authorized test target only
- No exploitation attempted
- OSINT performed manually
- Results are point-in-time
- Nmap default scripts ≠ full vulnerability assessment

---

## Appendix
All raw artifacts preserved in this run directory.
EOF

###############################################################################
# Done
###############################################################################
echo "[+] Scan complete"
echo "    Report: $REPORT"
echo "    Review, add Google dork findings, refine risk rationales, then commit."
