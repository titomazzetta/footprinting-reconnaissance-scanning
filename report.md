# Unit 6 — Footprinting, Reconnaissance, and Scanning

**Target:** `scanme.nmap.org`  
**Resolved IP:** `45.33.32.156`  
**Run Timestamp:** `2026-02-04_204015`

> Authorized assessment of an intentionally exposed Nmap test host.  
> No exploitation performed.

---

## Executive Summary
A structured footprinting → reconnaissance → scanning workflow was executed to identify externally exposed services and assess high-level risk themes from a defensive perspective. All findings are supported by reproducible command output.

---

## 1) Footprinting (OSINT)
### Google Dorks (Manual)
- site:scanme.nmap.org
- site:nmap.org "scanme.nmap.org"
- "scanme.nmap.org" filetype:pdf
- "scanme.nmap.org" "password"


**Findings:**
- Search results returned only publicly known, instructional references describing `scanme.nmap.org` as an authorized Nmap scanning practice host.
- No indexed sensitive documents, credentials, configuration files, or other compromising content were identified.

**Conclusion:**  
OSINT searches did not reveal any unintended public exposure beyond expected documentation.


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
| Port | Proto | State | Service | Version / Notes |
|---:|:---:|:---:|:---|:---|
| 22 | tcp | open | ssh | OpenSSH 6.6.1p1 Ubuntu 2ubuntu2.13 (Ubuntu Linux; protocol 2.0) |
| 80 | tcp | open | http | Apache httpd 2.4.7 ((Ubuntu)) |
| 9929 | tcp | open | nping-echo | Nping echo |
| 31337 | tcp | open | tcpwrapped | (not shown) |

---

## 6) Risk Ratings
**Method:** Likelihood × Impact = Score

| Port | Service | Likelihood (1–5) | Impact (1–5) | Score | Rating | Rationale |
|---:|:---|:---:|:---:|:---:|:---:|:---|
| 22 | ssh | 3 | 3 | 9 | MED | (updated after review) |
| 80 | http | 3 | 3 | 9 | MED | (updated after review) |
| 9929 | nping-echo | 3 | 3 | 9 | LOW | (updated after review) |
| 31337 | tcpwrapped | 3 | 3 | 9 | MED | (updated after review) |

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

All raw artifacts are preserved under:

runs/2026-02-04_204015_scanme.nmap.org/

