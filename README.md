# README.md

## ksw 0.1.0 

### Daemonizable VPN killswitch for NetworkManager with DNS and IPv6 leak protection written in Bash

### Features:

- Works with NetworkManager VPN plugins. (Tested with OpenVPN)

- Works with both iptables and firewalld. (Tested with firewalld)

- Relies on NetworkManager Dbus API to determine if user disconnected from VPN, allowing for complete automation (no passwords) until user input makes sense.

- Allows access to local network.

- Temporarily disables IPv6 and drops all outgoing IPv6 traffic.

- Provides simple fix for DNS leaks.

- Automatically detects VPN nameservers.

- Requires minimal configuration. `ksw` just needs you to provide 4 configuration variables: 
  - What firewall are you using? 
  - What physical interface do you use to connect to the internet? 
  - What port does your VPN use to establish a connection?
  - What protocol does your VPN transmit over?

### Dependencies:

- NetworkManager (`ksw dns-leak-fix` requires `nmcli`)

- iptables or firewalld

### Installation & Setup:

Please follow your VPN provider's instructions on how to connect
via NetworkManager and the various NetworkManager VPN plugins. 
The following installation instructions are meant for Linux 
operating systems running systemd (the script itself is init 
agnostic).

#### Installation:

1. Download this repository or clone it using git.

   `git clone https://github.com/tinfoil-hacks/ksw.git`

2. Edit the kswd.service unit file (if you use iptables).
   
   ```
   Requires=iptables.service ip6tables.service
   ```

3. Edit ksw.conf, providing the correct variables.

4. `sudo ./install.sh`.

    - `ksw` --> `/usr/local/sbin/ksw`

    - `ksw.conf` --> `/etc/ksw/ksw.conf`

    - `kswd.service` --> `/usr/lib/systemd/system/kswd.service`

5. `sudo systemctl daemon-reload`

6. `sudo systemctl enable --now kswd.service`

#### DNS Leak Fix

NetworkManager leaks DNS requests like a seive by default. To fix 
this, each VPN profile needs to be modified so that 
`ipv4.dns-priority=-1`. This can be automated by running 
`sudo ksw dns-leak-fix`. This takes care of all currently 
configured VPN connections, but needs to be done each time you 
upload a new VPN configuration to NetworkManager.

### Use

- `ksw on` - Turns on killswitch. (Not needed if ran as a service.)

- `ksw off` - Turns off killswitch. (Needed if VPN disconnects w/o user input.)

- `ksw daemon` - Runs ksw as a daemon (automatic mode). This is mainly for debugging. Enable `kswd` as a service instead.

- `ksw dns-leak-fix` - Prevents DNS leaks by modifying VPN connection settings. 

- `ksw version` - Display version number.

- `ksw help` - Prints these options to screen.

Running as a daemon, `ksw` only requires user input if your VPN 
connection is disconnected by something other than yourself. In the 
case of a failed VPN connection, discontinue all sensitive internet
activity (quit out of your browser and/or torrent client), then run 
`sudo ksw off` to regain access to the network. 

### Issues:

#### Trouble accessing local network services while connected to VPN

Running `ksw dns-leak-fix` disables your local DNS settings when a 
VPN is active. This means that any scripts or programs that depend 
upon local DNS information will not function as expected while you 
are connected to a VPN. Most of the time, fixing this is as simple 
as configuring your router to lease DHCP addresses indefinitely and 
using IP addresses instead of domain names for your scripts when 
necessary.

##### Printing

By default, CUPS uses your local DNS to find printers. This can be 
mitigated by [manually configuring your printer using its IP 
address](https://www.cups.org/doc/network.html). 

#### User defined outbound firewall rules are not supported

Currently, `ksw` does not support user-defined outbound firewall 
rules. Inbound rules, however, are never touched. 

#### Other

Please don't be afraid to submit issues or pull requests regarding 
fixes for other commonly used software.
