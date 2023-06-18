apk add nfs-utils
rc-update add nfs
rc-update add nfsmount
rc-service nfs start
rc-service nfsmount start
rc-status
eacho "If nfs services are not started the system may need a reboot."