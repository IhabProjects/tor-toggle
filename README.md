# Tor Toggle Script

This script allows you to enable or disable routing network traffic through the Tor network on Arch Linux using `iptables` and `systemd`.

## Features
- Enables Tor by starting the `tor.service` and redirecting HTTP/HTTPS traffic to Tor's transparent proxy.
- Disables Tor by stopping the service and removing the `iptables` rules.
- Simple command-line usage.

## Requirements
- Arch Linux
- `tor` package installed (`sudo pacman -S tor`)
- Root privileges to modify `iptables` rules and manage services

## Installation
1. Clone the repository:
   ```bash
   git clone https://github.com/IhabProjects/tor-toggle.git
   cd tor-toggle
   ```
2. Make the script executable:
   ```bash
   chmod +x tor_toggle.sh
   ```

## Usage
Run the script with `sudo`:

- **Activate Tor routing:**
  ```bash
  sudo ./tor_toggle.sh activate
  ```
  This starts the Tor service and routes all HTTP (port 80) and HTTPS (port 443) traffic through Tor.

- **Deactivate Tor routing:**
  ```bash
  sudo ./tor_toggle.sh deactivate
  ```
  This stops the Tor service and removes the `iptables` rules.

## Firefox Configuration
If Firefox does not work after activation, make sure it is set to **"Use system proxy settings"**:
1. Open Firefox settings.
2. Scroll down to **Network Settings** → Click **Settings…**.
3. Select **"Use system proxy settings"** and click **OK**.

## Checking `iptables` Rules
To verify that the `iptables` rules are applied correctly, run:
```bash
sudo iptables -t nat -L -v --line-numbers
```

## Restarting Tor and Network Services
If you encounter issues, try restarting the services:
```bash
sudo systemctl restart tor.service
sudo systemctl restart NetworkManager
```

## License
This script is open-source and available under the MIT License.

## Author
Created by Ihab ELBANI (@IhabProjects).

