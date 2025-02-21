#!/bin/bash
# tor_toggle.sh
# This script toggles Tor network connectivity on an Arch Linux system.
# Usage: sudo ./tor_toggle.sh [activate|deactivate]
#
# When run with "activate", the script starts the Tor service and adds iptables rules
# to redirect TCP traffic on ports 80 and 443 through Tor's transparent proxy (port 9040).
#
# When run with "deactivate", it removes those iptables rules and stops the Tor service.
#
# IMPORTANT: This script assumes no other critical iptables NAT rules are in place.
#           If you have a custom firewall setup, please back up your iptables configuration
#           before using this script.

# Check if the script is run as root.
if [[ $EUID -ne 0 ]]; then
    echo "This script must be run as root. Please use sudo."
    exit 1
fi

# Ensure exactly one argument is provided.
if [ "$#" -ne 1 ]; then
    echo "Usage: $0 [activate|deactivate]"
    exit 1
fi

case "$1" in
    activate)
        echo "Activating Tor network..."
        # Start the Tor service
        systemctl start tor.service
        
        # Add iptables rules to redirect HTTP and HTTPS traffic to Tor's transparent proxy
        iptables -t nat -A OUTPUT -p tcp --dport 80 \
            -m comment --comment "tor_rule" -j REDIRECT --to-ports 9040
        iptables -t nat -A OUTPUT -p tcp --dport 443 \
            -m comment --comment "tor_rule" -j REDIRECT --to-ports 9040
        
        echo "Tor network activated."
        ;;
    deactivate)
        echo "Deactivating Tor network..."
        # Remove the iptables rules tagged with "tor_rule".
        # These commands attempt to delete the rules; errors (if the rules are absent) are suppressed.
        iptables -t nat -D OUTPUT -p tcp --dport 80 \
            -m comment --comment "tor_rule" -j REDIRECT --to-ports 9040 2>/dev/null
        iptables -t nat -D OUTPUT -p tcp --dport 443 \
            -m comment --comment "tor_rule" -j REDIRECT --to-ports 9040 2>/dev/null
        
        # Stop the Tor service
        systemctl stop tor.service
        
        echo "Tor network deactivated."
        ;;
    *)
        echo "Usage: $0 [activate|deactivate]"
        exit 1
        ;;
esac
