#!/bin/bash

# API KEYS
API_URLSCAN= #ADD YOUR OWN KEY HERE
API_VIRUSTOTAL= #ADD YOUR OWN KEY HERE








## Code Starts here:

# Clear the terminal screen before starting
clear
clear
clear
echo "__________                             ___________           .__
\______   \ ____   ____  ____   ____   \__    ___/___   ____ |  |  
 |       _// __ \_/ ___\/  _ \ /    \    |    | /  _ \ /  _ \|  |  
 |    |   \  ___/\  \__(  <_> )   |  \   |    |(  <_> |  <_> )  |__
 |____|_  /\___  >\___  >____/|___|  /   |____| \____/ \____/|____/
        \/     \/     \/           \/                              

"


# Create the directory
dir_name=$(date +"%b%d_%Y_%H%M%S")
mkdir "$dir_name"


# Function to check if the input is an IP address (IPv4 or IPv6)
is_ip_address() {
    local ip=$1
    if [[ $ip =~ ^[0-9]+\.[0-9]+\.[0-9]+\.[0-9]+$ ]] || [[ $ip =~ ^([0-9a-fA-F]{1,4}:){1,7}[0-9a-fA-F]{1,4}$ ]]; then
        return 0
    else
        return 1
    fi
}


# Get the local host IP
LOCALHOST_IP=$(curl -s "https://ifconfig.so")
LOCALHOST_LOCATION=$(curl -s "https://ipinfo.io/$LOCALHOST_IP/json" -o "$dir_name/localhost_ipinfo.json" )
LOCALHOST_CITY=$(curl -s "https://ipinfo.io/$LOCALHOST_IP/json" | jq '.city')
LOCALHOST_REGION=$(curl -s "https://ipinfo.io/$LOCALHOST_IP/json" | jq '.region')
LOCALHOST_COUNTRY=$(curl -s "https://ipinfo.io/$LOCALHOST_IP/json" | jq '.country')


# Check if an argument is provided
if [ $# -eq 0 ]; then
    echo "Usage: $0 <domain_or_ip>"
    exit 1
fi


echo -e "\n\n=================================================="
echo "Initializing scan..."
echo "Scanning from host ip: $LOCALHOST_IP" 
echo "Approximate Location: $LOCALHOST_CITY, $LOCALHOST_REGION, $LOCALHOST_COUNTRY"

# Ask the user if they want to continue
read -p "Do you want to continue? (y/n): " answer

# Check the user's answer
if [ "$answer" == "n" ] || [ "$answer" == "N" ] || [ "$answer" == "NO" ] || [ "$answer" == "no" ]; then
    echo "Exiting program."
    echo -e "==================================================\n\n"
    exit 0
fi
echo -e "==================================================\n\n"


echo "=================================================="
echo -e "Starting Scan:\n"

# Assign the first argument to TARGET
TARGET="$1"

# Check if TARGET is an IP address
if is_ip_address "$TARGET"; then
    TARGET_IP="$TARGET"
    echo "Target IP Address: $TARGET_IP"
    VT_SCAN=$(source ./vt-scan/vt-scan.sh -k $API_VIRUSTOTAL -i $TARGET_IP)
    echo "$VT_SCAN" > $dir_name/vt-scan.json
    echo -e "\nUsing VirusTotal:"
    echo "New file created at: ./$dir_name/vt-scan.json"
else
    # If it's not an IP, use ping to resolve the domain to an IP address
    PING_OUTPUT=$(ping -c 1 "$TARGET" 2>/dev/null)
    
    # Check for IPv4 address
    TARGET_IP=$(echo "$PING_OUTPUT" | grep -o '[0-9]\{1,3\}\.[0-9]\{1,3\}\.[0-9]\{1,3\}\.[0-9]\{1,3\}' | head -n 1)
    
    # Check if we got an IP address
    if [ -z "$TARGET_IP" ]; then
        echo "Failed to resolve IPv4 address for $TARGET"
        exit 1
    fi

    SCAN_URLSCAN=$(curl -s -X POST "https://urlscan.io/api/v1/scan/" -H "Content-Type: application/json" -H "API-Key: $API_URLSCAN" -d "{ \"url\": \"$TARGET\", \"visibility\": \"public\" }" -o "$dir_name/urlscan.json")

    SCAN_RESULT=$(echo "$SCAN_URLSCAN" | grep "result")
    
    echo "Target Domain: $TARGET"
    echo "Target IPv4 Address: $TARGET_IP"
    echo -e "\nUsing:  urlscan.io"
    echo "New file created at: ./$dir_name/urlscan.json"

    VT_SCAN=$(source ./vt-scan/vt-scan.sh -k $API_VIRUSTOTAL -u $TARGET)
    echo "$VT_SCAN" > $dir_name/vt-scan.json
    echo -e "\nUsing VirusTotal:"
    echo "New file created at: ./$dir_name/vt-scan.json"
fi

echo -e "\nUsing: ipinfo.io"

# Use ipinfo.io to get location data for the IP address
TARGET_LOCATION=$(curl -s "https://ipinfo.io/$TARGET_IP/json" -o "$dir_name/ipinfo.json" )
echo "New file created at: ./$dir_name/ipinfo.json"

# Echo the location data
echo "$TARGET_LOCATION"

echo "Using who.is on $TARGET:"

# Use whois to get whois information
WHOIS_INFO=$(whois "$TARGET")
echo "$WHOIS_INFO" > $dir_name/whois.md
echo "New file created at: ./$dir_name/whois.md"

echo -e "=================================================="

curl -s -H "Content-Type: application/json" -H "API-Key: $API_URLSCAN" "https://urlscan.io/user/quotas/" -o "$dir_name/urlscan_quota.json"


echo -e "\n\n=================================================="
echo -e "Useful Links:\n"
echo "https://www.virustotal.com/gui/domain/$TARGET" 
echo "https://search.onyphe.io/search?q=domain:$TARGET"
echo "https://search.odin.io/hosts?query=$TARGET"
echo "https://www.infobyip.com/ip-$TARGET.html"
echo "Further ip/domain forensics: https://hackertarget.com/"
echo "OSINT Tools: https://osintframework.com/"
echo -e "==================================================\n\n"

echo "Suggested nmap scan: threader3000 $TARGET_IP"
read -p "Executing this command will clear this screen and terminate this script. Do you want to procced? (y/n): " answer

if [ "$answer" == "n" ] || [ "$answer" == "N" ] || [ "$answer" == "NO" ] || [ "$answer" == "no" ]; then
    echo "Exiting program."
    exit 0
fi

threader3000 $TARGET_IP 

exit 0