# RetroNAS

[About](#About) | [WARNING Security](#WARNING-Security) | [Tools and Systems](#Tools-and-Systems) | [WARNING Filenames](#WARNING-Filenames) | [Contributing](#Contributing) | [Thanks and Credits](#Thanks-and-Credits) | [How To](#How-To) 

# Status

RetroNAS is a tool that installs other tools. RetroNAS operates as a rolling release, i.e. each time the command line "retronas" tool is run the core project is updated to its latest stable release. The third party tools that RetroNAS provides installers and configuration for are managed via a mix of Debian APT repositories (standard linux system tooling), build scripts and for specialised tools via their upstream project pages. All tools will attempt to update when re-running the tool installer. 

Features are promoted from a feature branch into a branch called `testing` where it will sit until we are comfortable with the feature before being promoted to the "stable" `main` branch.

Branches
- `feature_name`: new features WIP, may be broken
- `testing`: new complete work, needs to be tested further
- `main`: considered stable

Users can opt in/out of these brances using the `Branch` tool available in the Update menu. It is suggested you only opt into the `testing` branch if you wish you provide feedback on new features we consider complete, are having issues with a particular tool or are told in an issue that a fix has been pushed to this branch. Opting into a `feature_name` branch will not receive any support as the work is not considered complete until it has moved to `testing`.

Please read the [Wiki](https://github.com/retronas/retronas/wiki) to see what's going on.

# About

RetroNAS is a suite of tools designed to turn a low cost Raspberry Pi, old computer or even Virtual Machine into a NAS (Network Attached Storage) device for retro PCs, microcomputers and consoles.

You can use it as a central file store or backup server for your old and new computers and consoles, a NAS with far more space than your old systems can natively attach (far exceeding the 2TB limit of solutions like FAT32 formatted direct-attached drives), or as a file drop between various computers that may not be compatible with each other's various network file sharing tools. It also offers some interesting tools like proxies to help very old web browsers read and download information from the modern Internet. 

It uses a number of open source tools to configure services and network protocols not found on modern NAS devices that are compatible with a large variety of retro systems.

In general, most of these services require a client with some sort of TCP/IP stack. There are exceptions however. e.g.: EtherDFS, as a dedicated Layer 2 protocol for MS-DOS machines with a packet driver and matching client software, or AppleTalk, Apple's pre-TCP protocol for AppleShare and AFP (Apple Filer Protocol) file sharing (although RetroNAS also supports AFP over TCP for newer Macs). 

You will generally need to have some sort of home TCP/IP based network with the correct hubs/switches, cables and NICs (Network Interface Cards) for this to work. 

Future options are planned to integrate dial-up modem, PPP or SLIP connected systems.  This is currently work in progress.

For a complete guide and list of supported systems and protocols, see the [Wiki](https://github.com/retronas/retronas/wiki) section.

If you want to chat about RetroNAS, come say hi on [Twitter](https://twitter.com/_daemons).

# WARNING Security

Due to the nature of retro computing, many of the tools and protocols used in this project are **COMPLETELY INSECURE**.

Most of these offer little to no encryption of either data or passwords, some offer access to your system without any authentication at all, and some of the protocols have known exploits that cannot be fixed due to their legacy design.

Please consider using this software only on a private network, and at the very least behind a firewall that denies inbound traffic from the Internet.

The services RetroNAS installs will attempt to run as unprivileged user accounts where possible, but the RetroNAS installer scripts themselves all run as root/sudo (the "Adminstrator" account in Linux). These have the power to dramatically change and break working systems, so please ensure you either review the code first, or run this only on a system dedicated to the purpose.

If you want a modern, secure, open source NAS and have no interest in retro systems, projects like Open Media Vault, TrueNAS, UnRAID or vendor supplied devices like QNAP and Synology NAS devices might be a better fit.

# Tools and Systems
RetroNAS is intended as a generalised hub for retro activities supporting as many legacy/retro systems as possible. With the intent to "support the unsupported" inclusion of certain systems and related tools is at the discretion of the project. As a general rule, tooling for systems that are still actively available for retail sale should/will not be added until a reasonable period has passed since retail sale has ended.

If a system has some sort of network capabilities and an open source service exists to serve that capability, RetroNAS can attempt to integrate it

Some of the projects/protocols include are:
* Samba 4.X - LANMan (NTLMv1, NTLMv2), NetBIOS, CIFS, SMB
* Netatalk 4.X - AFP / Apple Filing Protocol over AppleTalk and TCP/IP
* EtherDFS - layer 2 file sharing for MS-DOS
* FTP - Common file transfer protocol
* TFTP - Lightweight trivial file transfer protocol
* lighttpd HTTP - Web server for all HTTP clients and web browsers
* ps3netsrv - File streaming for PlayStation 3 + CFW/HEN + MultiMan or webMAN MOD

Some of the supported systems include:
* MS-DOS and clones such as PC-DOS and FreeDOS
* Microsoft Windows 95 and up
* Apple GS/OS, Classic Mac System 6 and System 7
* Apple Mac OS8, OS9, OS X 10.0 and up
* Atari ST with FTP client or HTTP browser
* Amiga Workbench 3.X and up with FTP client or HTTP browser
* Nintendo 3DS with Homebrew Channel and FBI installer
* Nintendo GameCube with BroadBand Adaptor and Swiss homebrew
* Sony PlayStation 2 with OpenPS2Loader
* Sony PlayStation 3 with CFW/HEN and webMAN-MOD
* Microsoft XBox 360 with JTAG/RGH, custom dash and ConnectX plugin
* MiSTer FPGA
* [Many more planned](https://github.com/retronas/retronas/wiki/Ideas)

Some of the extra services include:
* WebOne HTTP proxy for legacy web browsers without SSL/TLS or Web2.0 support to browse the modern Internet
* Syncthing secure personal file sharing with no cloud services needed
* gogrepo - back up your entire GOG library for DRM-free offline installs
* [Many more planned](https://github.com/retronas/retronas/wiki/Ideas)

Please see the [How To](#How-To) section for a comprehensive list of all protocols, supported systems and features.

# WARNING Filenames

Due to the retro nature of computing, it's strongly advised to follow some basic guidelines when using RetroNAS:

* Linux filesystems are case sensitive, but most old computers and operating systems are not (some new ones aren't either). It's strongly recommended to name all files and folders **lower case** in Linux where possible. Files like "filename.txt" and "Filename.txt" will appear identical to some legacy operating systems, and may confuse them. 
* Linux can read filenames up to 255 characters in length, but most old computers and operating systems cannot.  It is strongly recommmended to keep the main RetroNAS top level directory and the main directories below it to **8 characters or fewer**. 
* If wanting to share files with very old operating systems, it's strongly recommended to name them in an "8.3" format (8 charcters or fewer for the filename, 3 characters or fewer for the file extension). 
* Some operating systems can handle all sorts of interesting special characters and spaces in file names, some cannot.  It's strongly recommended to avoid any characters outside of regular English characters ("a-z"), numbers ("0-9") hyphen ("-") and underscore ("_ ") and stick with character encodings such as ASCII or UTF-8.

# Contributing 
This project is in a perpetual state of early development, as such things can change quickly.

Community feedback and bug reporting is vital. Use "Issues" to report problem, Issues are not intentded for feature requests nor generalised support. When reporting an issue please include the branch you are currently on which is reported on the main menu in current releases of RetroNAS.

We have [Discussions](https://github.com/orgs/retronas/discussions) open for general help with getting things working, feature requests and community tutorials.

Client-side documentation is also quite limited currently. Making videos showing how to use RetroNAS with retro computers and consoles is time consuming, so if you have done so, please let everyone know about your videos in the "Discussion" pages.

A number of people have asked for it to be available as a Docker container for Synology/QNAP/UnRAID style setups, however there will be limitations with this method (e.g. port conflicts with internal SMB/CIFS, non-IP traffic like AppleTalk/EtherDFS probably won't work, etc, and likewise managing the numerous services that all need to start and currently rely on systemd). For simple SMB/CIFS things like MiSTer and OpenPS2Loader, it may be possible to integrate with these devices.

# Thanks and Credits

"If I have seen further it is by standing on the shoulders of Giants" -- Sir Isaac Newton

RetroNAS is set of scripts that utilise Ansible to install and configure a wide array of open source tools written by others. The true heroes are the people behind each of these open source projects, all of whom have done the hard work - reverse engineering proprietary code/protocols, creating new code/protocols, writing homebrew tools and new code for old consoles and computers, and giving them all away under permissive licenses.  This project would not exist without their work. 

See the [Wiki](https://github.com/retronas/retronas/wiki) section for a list of all the tools included, and acknowledgement of the individual authors behind them. Without these people, this project could not exist.

Thanks to Dan of [StickFreaks](https://stickfreaks.com/) for putting together the initial versions of RetroNAS

Thanks to the kind humans on the [OCAU](https://forums.overclockers.com.au/forums/retro-arcade.92/) (Overclockers Australia) forums Retro section who have been brave enough to test this in early alpha stages, give feedback on things, recommend packages, and be generally enthusiastic.

Thanks to Bob from [RetroRGB](https://www.retrorgb.com/) for being excited about every dumb idea I come up with, and constantly reminding me that real people need better UX. 

Thanks to [sairuk](https://mameau.com/) for not only cleaning up my garbage code, but also for extending the project much further than I ever could. 

# How To

Full howto in the wiki: https://github.com/retronas/retronas/wiki
