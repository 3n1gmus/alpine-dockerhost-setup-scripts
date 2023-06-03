# alpine-dockerhost-setup-scripts
Scripts for setting up a docker host on alpine linux

1. alpine-setup.sh
- Installs base software for the docker host
- Assumes host is a qemu VM, comment out qemu-guest-agent items in script if running on bare-metal or other.

2. Alpine-powershell.sh
- Installs PowerShell in alpine linux.
- I use PowerShell scripts to manage docker backups 

3. alpine-format-ext4.sh
- Partitions and formats additional volumes.
- Adds volumes to Fstab and mounts them.
- Varibles in the scrip need to be updated to work properly with the given system.

4. alpine-static-ip.sh
- Configures NIC with given variables.
- Will only configure 1 interface, this is for a quick NIC setup.

5. Configure-ssh.sh
- Sets ssh security best practices.

6. iptables-docker-firewall.sh
- Opens firewall ports for SSH and all docker exposed ports.