

VERSIONING & ATTRIBUTION
-
- Script Author:        Terrence Houlahan, Linux & Network Engineer F1Linux.com
- Author Site:          http://www.F1Linux.com

- Script Version:       1.00.00
- Script Date:          20230916

These scripts and others by the author can be found at:

- [https://github.com/f1linux](https://github.com/f1linux)


INTRO
-

This script automates the grunt work of configuring an **UBUNTU** SystemD host to automount an NFS share.

However, for non-Debian Linux OS', if you replace the package management commands of the script with your particular package management commands it should just work on your own SystemD Linux OS.

INSTRUCTIONS
-

These are located on the script itself "config-NFS-SystemD-mounts.sh" but generally just change the values of the variables and then execute the script. It will install some NFS packages, create a SystemD mount and finally the related SystemD service to mount it. Obviously you should have created the NFS share on the storage host in advance of using this script.


iSCSI ?!?!?
-

Although NFS is suitable for sharing a filesystem across hosts, if you don't want frequent writes trashing your MicroSD card, I have a repoo that automates raising an iSCSI volume which avoids direct writes to the local filesystem. I did this for 8GB Raspberry Pi hosts so II could run Docker containers on them:

https://github.com/f1linux/iscsi-automount

Again, different use case, but if you want to run Docker on a Pi and you have a storage appliance that exports LUNs, this is probably what you want.



Apologies
-

I have an overpriced Mac with a shitty, not-fit-for-purpose keyboard that repeats characters. Vi doesn't spell check, so apologies if the spellling is wrong in places ;-)
