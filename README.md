# NRD Live List Generator
NRD Live List Generator is a PowerShell-based utility that retrieves newly registered domains (NRDs), performs basic HTTPS reachability validation, and generates a local HTML report containing only domains that respond successfully over HTTPS.

This project is designed for security research of newly registered domains, which are frequently associated with phishing, malware delivery, and fraud.

## Overview
The script provides the following capabilities:
1. Downloads a feed of newly registered domains and limits processing to the first 50 returned domains
3. Tests HTTPS reachability
5. Generates a HTML report with clickable links
6. Automatically opens the generated report

## Data Source
Domains are fetched from https://shreshtait.com/newly-registered-domains/nrd-1w

This feed contains domains registered within the last seven days.

## Requirements
- Windows PowerShell 5.1 or higher.

## Usage
1. Clone or download this repo
2. Open a PowerShell session
3. Navigate to the script directory
4. Run the script: `.\NRD-Live-List-Generator.ps1`

## Security Guidance
Newly registered domains often present elevated risk. Before accessing any links, it is recommended to use Remote Browser Isolation or an equivalent security solution.

## License
Licensed under MIT — free to use, modify, and share, with no warranty.

## Disclaimer
Newly registered domains are frequently associated with phishing, malware, and fraud. This project does not validate domain safety and should not be used as a trust signal. Accessing any generated links is done entirely at the user’s own risk.
