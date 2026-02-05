#Footprinting, Reconnaissance & Scanning

This repository contains a **controlled, authorized reconnaissance and network scanning assessment** conducted as part of **Unit 6: Footprinting, Reconnaissance, and Scanning**.

The project demonstrates practical OSINT, DNS analysis, WHOIS investigation, enumeration, and Nmap-based service discovery against an **explicitly permitted test host**.

---

## ⚠️ Authorization & Scope

- **Target:** `scanme.nmap.org`
- **Owner:** Nmap Project (publicly authorized testing host)
- **Scope:** External reconnaissance and scanning only
- **No exploitation performed**
- **Educational use only**

Any reuse of this tooling **must be limited to systems you own or have written permission to test**.

---

## Repository Structure

```
Footprinting-Reconnaissance-Scanning/
├── scripts/
│   └── u6_scanme_pipeline.sh      # Automated recon + scan pipeline
├── runs/
│   └── 2026-02-04_204015_scanme.nmap.org/
│       ├── report.md              # Full technical assessment
│       ├── dig.txt
│       ├── nslookup.txt
│       ├── reverse_dns.txt
│       ├── dnsrecon.txt
│       ├── whois_domain.txt
│       ├── whois_ip.txt
│       ├── nmap_top1000.txt
│       ├── nmap_service_scan.txt
│       ├── nmap_service_scan.gnmap
│       └── nmap_service_scan.xml
├── README.md
└── .gitignore
```

---

## Tools & Techniques Used

### Footprinting / OSINT
- Google Dorking (manual)
- Public DNS inspection

### DNS Reconnaissance
- `dig`
- `nslookup`
- `host`
- `dnsrecon`

### WHOIS
- Domain-level WHOIS
- IP-level WHOIS (ARIN)

### Network Scanning
- `nmap`
  - Top 1000 TCP ports
  - Service & version detection
  - Default NSE scripts

---

## How to Run

```bash
chmod +x scripts/u6_scanme_pipeline.sh
./scripts/u6_scanme_pipeline.sh
```

> macOS-compatible (uses `-sT` TCP connect scan to avoid root privileges)

All artifacts are saved under a timestamped directory in `runs/`.

---

## Key Findings (Summary)

- Exposed services:
  - SSH (22/tcp)
  - HTTP (80/tcp)
  - Nping Echo (9929/tcp)
  - tcpwrapped service (31337/tcp)
- Public cloud hosting (Akamai / Linode)
- No DNS zone transfer possible
- No immediate critical vulnerabilities identified without exploitation

Full details are documented in:
```
runs/<timestamp>_scanme.nmap.org/report.md
```

---

## Risk Assessment

Each exposed service is evaluated using:

```
Risk Score = Likelihood × Impact
```

Ratings are qualitative and designed for **defensive prioritization**, not exploitation.

---

## Limitations

- Point-in-time snapshot
- No credentialed access
- No exploitation or brute-force attempts
- OSINT limited to publicly available data
- Nmap default scripts ≠ full vulnerability assessment

---

## Skills Demonstrated

- Ethical reconnaissance methodology
- DNS and network protocol analysis
- Secure scanning practices
- Risk-based security thinking
- Reproducible technical reporting
- Linux/macOS command-line proficiency

---

## Disclaimer

This project is for **educational purposes only**.
Unauthorized scanning of systems is illegal and unethical.
