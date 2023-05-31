# alpine-dockerhost-setup-scripts
Scripts for setting up a docker host on alpine linux

1. alpine-setup.sh
- Installs base software for the docker host
- Assumes host is a qemu VM, comment out qemu-guest-agent items in script if running on bare-metal or other.

2. Alpine-powershell.sh
- Installs PowerShell in alpine linux.
- I use PowerShell scripts to manage docker backups 
