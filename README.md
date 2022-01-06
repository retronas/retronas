# RetroNAS

[About](#About) | [WARNING Security](#WARNING-Security) | [Supported Systems](#Supported-Systems) | [WARNING Filenames](#WARNING-Filenames) | [Thanks and Credits](#Thanks-and-Credits) | [How To](#How-To) 

# About

RetroNAS is a suite of tools designed to turn a low cost Raspberry Pi into a NAS (Network Attached Storage) device for retro PCs, microcomputers and consoles.

It uses a number of open source tools to configure services and network protocols compatible with a large variety of retro systems.

In general, most of these services require a client with some sort of TCP/IP stack. There are exceptions however (e.g.: EtherDFS, as a dedicated Layer 2 protocol for MS-DOS machines with a packet driver and matching client software).

You will generally need to have some sort of home TCP/IP based network with the correct hubs/switches, cables and NICs (Network Interface Cards) for this to work. 

Future options are planned to integrate dial-up modem, PPP or SLIP connected systems.  This is currently work in progress.

For a complete guide and list of supported systems and protocols, see the [How To](#How-To) section.

# WARNING Security

Due to the nature of retro computing, many of the tools and protocols used in this project are **COMPLETELY INSECURE**.

Most of these offer little to no encryption of either data or passwords, some offer access to your system without any authentication at all, and some of the protocols have known exploits that cannot be fixed due to their legacy design.

Please consider using this software only on a private network, and at the very leased behind a firewall that denies inbound traffic from the Internet.

The services RetroNAS installs will attempt to run as unprivileged user accounts where possible, but the RetroNAS installer scripts themselves all run as root/sudo. These have the power to dramatically change and break working systems, so please ensure you either review the code first, or run this only on a test system you don't care about.

# Supported systems

RetroNAS aims to support as many legacy and retro systems as possible. If a system has some sort of network capabilities and an open source service exists to serve that capability, RetroNAS can attempt to integrate it.

Some of the projects/protocols include are:
* Samba - LANMan, NetBIOS, NetBEUI, CIFS, SMB
* Netatalk - AppleTalk, AFP
* EtherDFS - layer 2 file sharing for MS-DOS
* FTP
* TFTP
* lighttpd HTTP - Web server for all HTTP clients and web browsers
* ps3netsrv - File streaming for PlayStation 3 + CFW/HEN + webMAN MOD

Some of the supported systems include:
* MS-DOS and clones such as PC-DOS and FreeDOS
* Microsoft Windows 95 and up
* Apple Mac OS8, OS9, OS X 10.0 and up
* Atari ST
* Amiga Workbench 3.X and up
* Nintendo 3DS with Homebrew Channel and FBI installer
* Sony PlayStation 2 with OpenPS2Loader
* Sony PlayStation 3 with CFW/HEN and webMAN-MOD
* Microsoft XBox 360 with JTAG/RGH, custom dash and ConnectX plugin
* MiSTer FPGA
* Many more to be added!

Some of the extra services include:
* Nintendo 3DS with FBI - QR code auto generation for CIA installs over WiFi
* WebOne HTTP proxy for legacy web browsers without SSL/TLS or Web2.0 support to browse the modern Internet
* Syncthing secure personal file sharing with no cloud services needed
* Many more to be added!

Please see the [How To](#How-To) section for a comprehensive list of all protocols, supported systems and features.

# WARNING Filenames

Due to the retro nature of computing, it's strongly advised to follow some basig guidelines when using RetroNAS:

* Linux is case sensitive, but most old computers and operating systems are not. It's strongly recommended to name all files and folders **lower case** in Linux where possible.
* Linux can read filenames up to 255 characters in length, but most old computers and operating systems cannot.  It is stronly recommmended to keep the main RetroNAS top level directory and the main directories below it to **8 characters or fewer**.

# Thanks and Credits

"If I have seen further it is by standing on the shoulders of Giants" -- Sir Isaac Newton

RetroNAS is merely a small set of scripts that utilise Ansible to install and configure a wide array of open source tools.

The true heroes are the people behind each of these open source projects, all of whom have done the hard work, either reverse engineering proprietary code/protocols, or creating new code/protocols and giving them away under permissive licenses.

See the [How To](#How-To) section for a list of all the tools included, and acknowledgement of the individual authors behind them. Without these people, this project could not exist.

Thanks to the kind humans on the OCAU (Overclockers Australia) forums Retro section who have been brave enough to test this in early alpha stages, give feedback on things, recommend packages, and be generally enthusiastic.

Thanks to Bob from RetroRGB for being excited about every dumb idea I come up with, and constantly reminding me that real people need better UX. 

# How To

Full howto in the wiki: [https://github.com/danmons/retronas/wiki](https://github.com/danmons/retronas/wiki)
