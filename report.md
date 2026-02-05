# Unit 6 — Footprinting, Reconnaissance, and Scanning

**Target:** `scanme.nmap.org`  
**Resolved IP:** `45.33.32.156`  
**Assessment Date:** 2026-02-04  

> Authorized assessment of an intentionally exposed Nmap test host.  
> No exploitation performed.

---

## Executive Summary

A structured footprinting → reconnaissance → scanning workflow was executed to identify externally exposed services and assess high-level risk themes from a defensive perspective. All findings were derived from reproducible command execution and analyzed using standard cybersecurity reconnaissance methodology.

---

## 1) Footprinting (OSINT)

### Google Dorking (Manual)

The following Google search operators were used to identify publicly indexed information related to the target:

- `site:scanme.nmap.org`
- `site:nmap.org "scanme.nmap.org"`
- `"scanme.nmap.org" filetype:pdf`
- `"scanme.nmap.org" "password"`

### Findings

- Search results returned only publicly known, instructional references describing `scanme.nmap.org` as an authorized Nmap scanning practice host.
- No sensitive documents, credentials, configuration files, or unintended disclosures were identified.

**Conclusion:**  
OSINT searches did not reveal any unintended public exposure beyond expected documentation.

---

## 2) DNS Reconnaissance

DNS reconnaissance was performed to validate hostname resolution, DNS ownership, and infrastructure legitimacy.

### Methods Used
- `nslookup`
- `dig`
- Reverse DNS lookup

### Key Findings
- `scanme.nmap.org` resolves to IPv4 address `45.33.32.156`
- DNS records are properly configured with no anomalies
- Reverse DNS correctly maps the IP back to the domain
- DNS ownership indicates professionally managed infrastructure

---

## 3) WHOIS Analysis

WHOIS queries were performed to identify ownership and point-of-contact information.

### Key Findings
- The `.org` top-level domain is managed by the Public Interest Registry (PIR)
- The IP address belongs to Akamai Technologies / Linode infrastructure
- Ownership and contact information confirms legitimate hosting

---

## 4) Enumeration

Enumeration was conducted to identify additional DNS records or subdomains.

### Methods Used
- DNS enumeration using `dnsrecon`
- Name server interrogation
- Zone transfer testing (AXFR)

### Key Findings
- Name servers were identified
- Zone transfer attempts were denied
- No unintended subdomains or DNS records were exposed

---

## 5) Network Scanning

Active reconnaissance was performed using Nmap to identify exposed services.

### Methods Used
- TCP connect scan (`-sT`)
- Service/version detection (`-sV`)
- Default NSE scripts (`-sC`)
- Open ports only (`--open`)

### Open Ports Summary

| Port | Protocol | Service | Version |
|---:|:--------:|:--------|:--------|
| 22 | TCP | SSH | OpenSSH 6.6.1p1 (Ubuntu) |
| 80 | TCP | HTTP | Apache 2.4.7 |
| 9929 | TCP | nping-echo | Nping echo |
| 31337 | TCP | tcpwrapped | Obscured service |

---

## 6) Risk Ratings

**Methodology:** Likelihood × Impact = Risk Score

| Port | Service | Likelihood | Impact | Score | Rating | Rationale |
|---:|:---|:---:|:---:|:---:|:---:|:---|
| 22 | SSH | 3 | 3 | 9 | Medium | Common brute-force target; risk depends on authentication controls |
| 80 | HTTP | 3 | 3 | 9 | Medium | Public web service running outdated Apache version |
| 9929 | nping-echo | 2 | 2 | 4 | Low | Limited diagnostic service with minimal attack surface |
| 31337 | tcpwrapped | 3 | 3 | 9 | Medium | Unknown service increases uncertainty until fully validated |

---

## 7) Security Analysis

### Port 22 / SSH
SSH provides remote administrative access and is frequently targeted by automated attacks. While no vulnerabilities were detected, exposure increases risk without strong authentication and access controls.

### Port 80 / HTTP
The Apache service is outdated, which may expose known vulnerabilities if not patched. Public-facing web services require continuous monitoring and hardening.

### Port 9929 / nping-echo
This service is intentionally exposed for testing and responds only to Nping echo requests. Limited functionality significantly reduces exploitability.

### Port 31337 / tcpwrapped
The service obscures connection details, reducing information disclosure. However, unknown services should always be reviewed to confirm necessity.

### Overall Assessment
No critical vulnerabilities were identified. All exposed services appear intentional and consistent with an authorized testing environment.

---

## 8) Mitigation Recommendations

- Minimize externally exposed services
- Enforce key-based authentication and access restrictions
- Patch and harden public-facing software
- Implement monitoring and rate limiting
- Regularly review exposed services

---

## 9) Limitations

- Single authorized test host
- No credentialed access
- No vulnerability exploitation performed
- Results represent a point-in-time snapshot
- OSINT conducted manually

---

## Appendix

All reconnaissance and scanning steps were executed using a scripted pipeline to ensure repeatability.  
Automation code and methodology are available in the associated GitHub repository.

