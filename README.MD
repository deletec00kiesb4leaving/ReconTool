# IP and Domain Reconnaissance Tool

This Bash script is designed for reconnaissance on IP addresses and domain names, utilizing various API services to gather and compile information.

## Features
- **IP Detection**: Determines if the input is an IP address or domain name.
- **API Integration**: 
  - **Urlscan.io** for domain scanning.
  - **VirusTotal** for IP and domain reputation checks.
  - **ipinfo.io** for geolocation data.
- **Whois Information**: Retrieves and saves WHOIS data.
- **Quota Checking**: Checks your remaining API quotas for urlscan.io.

## Usage
Run the script with a domain or IP as an argument:

The script will:
- Create a directory with the current timestamp to store results.
- Ask for user confirmation before proceeding with the scan.
- Use various services to gather and save data in JSON or Markdown formats within the created directory.

## Output
- JSON files from urlscan.io, VirusTotal, and ipinfo.io
- Markdown file with WHOIS information

## Important Notes
- This tool respects user privacy by requiring explicit consent before scanning.
- Please be aware of and comply with the usage policies of the APIs you are using.

## License
This project is licensed under the **MIT License**.

## Contributing
Contributions are welcome! Please fork this repository and submit a pull request with your changes.

## Acknowledgments
- Thanks to the developers of urlscan.io, VirusTotal, and ipinfo.io for their services.
- Inspiration from various open-source reconnaissance tools.

## Contact
For any queries, feel free to open an issue or contact me ;)
