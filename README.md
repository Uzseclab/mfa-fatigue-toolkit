# MFA Fatigue Toolkit by Uzsec

A sophisticated toolkit for conducting MFA fatigue attacks against enterprise environments.

## Features

- **Multi-Platform Support**: Works with Azure AD, Okta, and Duo MFA systems
- **Smart Rate Limiting**: Implements random delays to avoid detection
- **Modular Architecture**: Easy to extend for additional MFA providers
- **Comprehensive Logging**: Detailed attack tracking and reporting
- **Payload Management**: Configurable user and password lists

## Installation

```bash
chmod +x install.sh
./install.sh
```

## **Usage**
### **Basic Usage**
```bash
./mfa-fatigue.sh -m azure -t 'contoso.onmicrosoft.com' -u payloads/users.txt -p payloads/passwords.txt
```
### **Advanced Usage**
```bash
./mfa-fatigue.sh -m okta -t 'contoso.okta.com' -u payloads/users.txt -p payloads/passwords.txt -r 2 -d 5 -l attack.log
```
## Options

    -m, --mode     MFA provider (azure, okta, duo)
    -t, --target   Target domain or URL
    -u, --users    Users file path
    -p, --passwords Passwords file path
    -r, --rate     Requests per second (default: 1)
    -d, --delay    Random delay range (default: 0)
    -l, --log      Log file path
    -h, --help     Show help message

## Recommanded Usage for Red Teams

     Initial Reconnaissance: Collect valid user accounts
     Password List Preparation: Create targeted password lists
     Rate Limiting: Use lower rates (1-2 requests/second) to avoid detection
     Random Delays: Add random delays between requests
     Multiple Targets: Rotate between different MFA providers

## Security Considerations

    Use this tool responsibly
    Ensure you have proper authorization
    Monitor for account lockouts
    Consider using rotating IP addresses
    Implement proper logging and monitoring

## Contributing

Contributions are welcome! Please submit pull requests for new MFA providers or features.
