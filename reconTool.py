# This script is used to perform reconnaissance on a target IP address.
# This is a re-write from the recon.sh tool previously written by me.
# This is underdevelopment and may not be fully functional.

# Author: deletec00kiesb4leaving
# Date: 2025-02-07

import subprocess
import re
import urllib.request



# API KEYS HERE
APIKEY_VIRUSTOTAL="YOUR_API_KEY_HERE" # Replace with your VirusTotal API key
APIKEY_URLSCAN ="YOUR_API_KEY_HERE" # Replace with your URLScan API key




# Functions
def continue_scan():
    print("Do you want to continue with the scan? (y/n)")
    if input().lower() == "y":
        print(f"\nProceding...\n")
        return True
    else:
        print(f"\nExiting ReconTool.\n")
        exit()

def is_ip_address(ip):
    # Define a regular expression pattern for IPv4 and IPv6 addresses
    ipv4_pattern = r'^([0-9]{1,3}\.){3}[0-9]{1,3}$'
    ipv6_pattern = r'^([0-9a-fA-F]{1,4}:){1,7}[0-9a-fA-F]{1,4}$'
    
    # Check if the input matches either IPv4 or IPv6 pattern
    if re.match(ipv4_pattern, ip) or re.match(ipv6_pattern, ip):
        return True
    else:
        return False

#def domain_ipv4(domain):
    # Converts Domain to IPv4
    #ipv4_address = str(domain)
    #if is_ip_address(ipv4_address):
        #return ipv4_address
    #else:
        #exit 0
    





# Welcome Text
subprocess.run("clear", shell=True)
print("Welcome to ReconTool!")
print("This script is used to perform reconnaissance on a target IP address.")
print("\n\nPlease understand that this tool will use your current IP address to scan the target IP.")
continue_scan()







# Get user input for target IP address
with urllib.request.urlopen('http://icanhazip.com/') as response:
   html = response.read()
   user_ip = html.decode('utf-8')

print(f"\nYour current IP address is:", user_ip)









# Step 1: Check if User's IP address is protected 
with urllib.request.urlopen('http://ipinfo.io/json') as response:
   html = response.read()
   user_ip_info = html.decode('utf-8')
   print(f"\nIP Info on your IP Address: ", user_ip_info, "\n")
    





# Step 2: Check for Domain recon or IP recon
target_ip = ""
decision = input("Do you want to perform domain recon or IP recon? (Enter 'domain' for domain recon, 'ip' for IP recon): ").lower()

if decision == "domain":
    domain = input("Enter the domain name to scan: ")
    #target_ip= str(domain_ipv4(domain))





# Step 3: Check if the target IP address is valid
while not is_ip_address(target_ip):
    print("Please enter a valid IPv4 or IPv6 address to scan.")
    target_ip = input()

if is_ip_address(target_ip):
    print("Valid. Performing reconnaissance on target IP address:", target_ip)

with urllib.request.urlopen('http://ipinfo.io/'+ str(target_ip) +'/json') as response:
   html = response.read()
   target_ip_info = html.decode('utf-8')
   print(f"\nIP Info on target IP Address: ", target_ip_info, "\n")
