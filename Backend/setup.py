import socket
import os
import platform

# Define the hostname you want to map to the local IP
HOSTNAME = "mywebsite.local"

# Path to the hosts file based on the platform
HOSTS_FILE = r"C:\Windows\System32\drivers\etc\hosts" if platform.system() == "Windows" else "/etc/hosts"

def get_local_ip():
    """Returns the local IP address of the current machine."""
    try:
        # Connect to an external IP (e.g., Google's public DNS) to find the local IP
        s = socket.socket(socket.AF_INET, socket.SOCK_DGRAM)
        s.connect(("8.8.8.8", 80))
        local_ip = s.getsockname()[0]
        s.close()
        return local_ip
    except Exception as e:
        print(f"Error obtaining local IP: {e}")
        return None

def read_hosts_file():
    """Reads and returns the content of the hosts file."""
    try:
        with open(HOSTS_FILE, 'r') as file:
            return file.readlines()
    except Exception as e:
        print(f"Error reading hosts file: {e}")
        return None

def write_hosts_file(content):
    """Writes the modified content back to the hosts file."""
    try:
        with open(HOSTS_FILE, 'w') as file:
            file.writelines(content)
    except Exception as e:
        print(f"Error writing to hosts file: {e}")

def update_hosts_file(ip_address):
    """Updates the hosts file to map the hostname to the local IP."""
    hosts_content = read_hosts_file()
    if hosts_content is None:
        print("Failed to read hosts file.")
        return

    # Flag to track if we found the hostname in the hosts file
    found = False
    updated_content = []

    for line in hosts_content:
        if HOSTNAME in line:
            # Update the IP address for the hostname
            updated_content.append(f"{ip_address} {HOSTNAME}\n")
            found = True
        else:
            # Keep the existing line unchanged
            updated_content.append(line)

    if not found:
        # Add the new IP-to-hostname mapping if it wasn't found
        updated_content.append(f"{ip_address} {HOSTNAME}\n")
        print(f"Added new entry: {ip_address} {HOSTNAME}")
    else:
        print(f"Updated {HOSTNAME} to new IP: {ip_address}")

    # Write the updated content back to the hosts file
    write_hosts_file(updated_content)

if __name__ == "__main__":
    local_ip = get_local_ip()
    if local_ip:
        print(f"Local IP: {local_ip}")
        update_hosts_file(local_ip)
    else:
        print("Unable to get the local IP address.")
