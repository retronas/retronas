# RetroNAS

[About](#About) | [WARNING Security](#WARNING-Security) | [Supported Systems](#Supported-Systems) | [WARNING Filenames](#WARNING-Filenames) | [Thanks and Credits](#Thanks-and-Credits) | [How To](#How-To) 

# About

RetroNAS is a suite of tools designed to turn a low cost Raspberry Pi into a NAS (Network Attached Storage) device for retro PCs, microcomputers and consoles.

You can use it as a central file store or backup server for your old and new computers and consoles, a NAS with far more space than your old systems can natively attach, or as a file drop between various computers that may not be compatible with each other's various network file sharing tools. It also offers some interesting tools like proxies to help very old web browsers read and download information from the modern Internet. 

It uses a number of open source tools to configure services and network protocols compatible with a large variety of retro systems.

In general, most of these services require a client with some sort of TCP/IP stack. There are exceptions however. e.g.: EtherDFS, as a dedicated Layer 2 protocol for MS-DOS machines with a packet driver and matching client software, or AppleTalk, Apple's pre-TCP protocol for AppleShare and AFP (Apple Filer Protocol) file sharing (although RetroNAS also supports AFP over TCP for newer Macs). 

You will generally need to have some sort of home TCP/IP based network with the correct hubs/switches, cables and NICs (Network Interface Cards) for this to work. 

Future options are planned to integrate dial-up modem, PPP or SLIP connected systems.  This is currently work in progress.

For a complete guide and list of supported systems and protocols, see the [How To](#How-To) section.

# WARNING Security

Due to the nature of retro computing, many of the tools and protocols used in this project are **COMPLETELY INSECURE**.

Most of these offer little to no encryption of either data or passwords, some offer access to your system without any authentication at all, and some of the protocols have known exploits that cannot be fixed due to their legacy design.

Please consider using this software only on a private network, and at the very least behind a firewall that denies inbound traffic from the Internet.

The services RetroNAS installs will attempt to run as unprivileged user accounts where possible, but the RetroNAS installer scripts themselves all run as root/sudo (the "Adminstrator" account in Linux). These have the power to dramatically change and break working systems, so please ensure you either review the code first, or run this only on a system dedicated to the purpose.

If you want a modern, secure, open source NAS for Raspberry Pi, please look at something like "Open Media Vault" instead.
* https://www.openmediavault.org/
* https://github.com/OpenMediaVault-Plugin-Developers/installScript/

# Supported systems

RetroNAS aims to support as many legacy and retro systems as possible. If a system has some sort of network capabilities and an open source service exists to serve that capability, RetroNAS can attempt to integrate it.

Some of the projects/protocols include are:
* Samba 4.X - LANMan (NTLMv1, NTLMv2), NetBIOS, CIFS, SMB
* Netatalk 2.X - AppleShare over AppleTalk
* Netatalk 3.X - AFP / Apple Filing Protocol over TCP
* EtherDFS - layer 2 file sharing for MS-DOS
* FTP - Common file transfer protocol
* TFTP - Lightweight trivial file transfer protocol
* lighttpd HTTP - Web server for all HTTP clients and web browsers
* ps3netsrv - File streaming for PlayStation 3 + CFW/HEN + MultiMan or webMAN MOD

Some of the supported systems include:
* MS-DOS and clones such as PC-DOS and FreeDOS
* Microsoft Windows 95 and up
* Apple Mac OS8, OS9, OS X 10.0 and up
* Atari ST with FTP client or HTTP browser
* Amiga Workbench 3.X and up with FTP client or HTTP browser
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
* gogrepo - back up your entire GOG library for DRM-free offline installs
* Many more to be added!

Please see the [How To](#How-To) section for a comprehensive list of all protocols, supported systems and features.

# WARNING Filenames

Due to the retro nature of computing, it's strongly advised to follow some basig guidelines when using RetroNAS:

* Linux filesystems are case sensitive, but most old computers and operating systems are not (some new ones aren't either). It's strongly recommended to name all files and folders **lower case** in Linux where possible. Files like "filename.txt" and "Filename.txt" will appear identical to some legacy operating systems, and may confuse them. 
* Linux can read filenames up to 255 characters in length, but most old computers and operating systems cannot.  It is stronly recommmended to keep the main RetroNAS top level directory and the main directories below it to **8 characters or fewer**. 
* If wanting to share files with very old operating systems, it's strongly recommended to name them in an "8.3" format (8 charcters or fewer for the filename, 3 characters or fewer for the file extension). 
* Some operating systems can handle all sorts of interesting special characters and spaces in file names, some cannot.  It's strongly recommended to avoid any characters outside of regular English characters ("a-z"), numbers ("0-9") hyphen ("-") and underscore ("_ ") and stick with character encodings such as ASCII or UTF-8.

# Thanks and Credits

"If I have seen further it is by standing on the shoulders of Giants" -- Sir Isaac Newton

RetroNAS is merely a small set of scripts that utilise Ansible to install and configure a wide array of open source tools written by others.

The true heroes are the people behind each of these open source projects, all of whom have done the hard work, either reverse engineering proprietary code/protocols, or creating new code/protocols and giving them away under permissive licenses.  This project would not exist without their work. 

See the [How To](#How-To) section for a list of all the tools included, and acknowledgement of the individual authors behind them. Without these people, this project could not exist.

Thanks to the kind humans on the OCAU (Overclockers Australia) forums Retro section who have been brave enough to test this in early alpha stages, give feedback on things, recommend packages, and be generally enthusiastic.

Thanks to Bob from RetroRGB for being excited about every dumb idea I come up with, and constantly reminding me that real people need better UX. 

# How To

Full howto in the wiki: [https://github.com/danmons/retronas/wiki](https://github.com/danmons/retronas/wiki)
