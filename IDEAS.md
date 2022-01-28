# Ideas to implement "one day"

## Commodore 64
* WiFi access point for C64-WiFi
* Disk emulator - Pi1541 - https://cbm-pi1541.firebaseapp.com/
* Tape emulator

## Audio player for tape based computers
* Push tape images over audio to compatible systems
  * Sega SC-3000 "bit" format
  * MSX "cas" format
  * Generic "wav" / "flac" formats
  * MAME castool frontend - https://docs.mamedev.org/tools/castool.html
* Test with cheap 3.5mm audio jack to tape player hardware
* Linux mpd + web interface to play audio files (mobile compatible), e.g.:
  * https://github.com/jcorporation/myMPD
  * https://github.com/rain0r/ampd 

## Apple, AppleTalk, Mac, Apple II
* Switch Netatalk2 from binary distribution to modern fork
  * https://github.com/rdmark/Netatalk
* timelord and tardis
  * https://macintoshgarden.org/apps/tardis-and-timelord
* A2BOOT (network boot Apple IIGS)
* MacIP
  * https://www.macip.net/
* ADTPro style serial boot for Apple II family machines
  * https://github.com/ADTPro/adtpro

## FTP client
* Something web based preferably
  * Allow push from RetroNAS to devices like modded Classic XBox, XBox 360

## GOG sync
* Sync all GOG purchases to NAS on cron schedule
  * https://github.com/eddie3/gogrepo
  * Mostly done, need multi-game select menu

## ROM auditing
* https://github.com/frederic-mahe/Hardware-Target-Game-Database
* Symlinks/Hardlinks for deduplication (filesystem specific)
  * https://github.com/markfasheh/duperemove

## Arcade Netboot
* PiForce - https://github.com/travistyoj/piforcetools
  * Supports Sega NAOMI, Chihiro, Triforce arcade hardware

## Nintendo GameCube
* Swiss + Broadband Adaptor for SMB/network game loading
  * GC serial port is 27 Mbit/s (3 MB/s)
  * GC optical inner is 2 MB/s reads
  * GC optical outer is 3.7 MB/s reads
  * Broadband adaptor limited by serial port.  Bandwidth about the same as an optical disc, but latency/seek would be much lower in theory. 

## ISO / CHD
* ISO checksum tool
* ISO <-> CHD converter (MAME chdman)
* ISO CD/DVD burner (via USB CD-R/DVD-R)
* Redump BIN/CUE optical drive ripper
  * http://wiki.redump.org/index.php?title=Dumping_Guides
  * https://github.com/SabreTools/MPF/

## Cloud drives, cloud sync
* rclone cloud sync / cloud drive mount
  * https://rclone.org/docs/
* Test stability/performance of cloud drives accessed from retro systems 
* Backup tools to push from RetroNAS to cloud

## File copying
* Good file copy/management tool
  * Midnight Commander? Something web based?
  * Copy between RetroNAS and external media or mounted filesystems

## DOS
* Build a floppy builder
  * Take ideas from ISOify - https://github.com/danmons/isoify
  * Build 512x20x18x2 (1.44MB) FAT12 floppy image files, lookback mount, copy data
  * Include tools for FlashFloppy export - https://github.com/keirf/FlashFloppy
* Add USB floppy disk support
  * Mount real floppy disks
  * Copy from RetroNAS to Floppy (individual files or raw image)
* PLIP (IP over Parallel port)
  * https://tldp.org/HOWTO/PLIP-1.html
* ethflop, floppy block device over L2 ethernet
  * http://ethflop.sourceforge.net/

## Bulletin Board / BBS tools
* Native Hosted, DOS VM maybe, expose local file system for file downloads
* Dialup integration via DreamPi
* IP based for ppp connections. telnet connections

## Dialup modem
* DreamPi - https://github.com/Kazade/dreampi
  * Test with other devices/OSes that can do dialup
  * RetroNAS access over modem
  * Internet access over modem (optionally via WebOne)

## Serial port
* USB to RS232/DB9
* RPi GPIO to RS232/DB9
* ppp support with dhcp
  * Test with null-modem compatible OSes - DOS, Win3.x, Win9x, Amiga, etc
  * RetroPi access over serial
  * Internet access over serial (optionally via WebOne)

## DHCP / DNS / PXE
* dnsmasq or something similar and simple
* Option to choose WiFi Bridge mode or secure "RetroLAN" NAT/Firewall mode
* PLOP boot manager for retro OS installs, utilities, add USB boot to retro PCs, etc
  * https://www.plop.at/en/bootmanager/index.html
* PXE / iPXE support + menus
  * OS installers (e.g.: FreeDOS via memdisk) 
  * iSCSI support
  * Floppy imager to build iPXE floppy

## Torrent server with client install instructions
* deluge-web https://deluge-torrent.org/

## Advanced file systems
* MDRAID
* LVM
* BtrFS + deduplication / compression / snapshots
  * https://github.com/markfasheh/duperemove

## GUI remote access
* VNC and RDP access for tools that don't have web interfaces
  * FileZilla (FTP push to devices like classic XBox)
  * ADT Pro for Linux (Apple II serial boot)

## Cockpit extensions
* SMB
  * https://github.com/enira/cockpit-smb-plugin
  * https://github.com/45Drives/cockpit-file-sharing
* File manager:
  * https://github.com/45Drives/cockpit-navigator
* ZFS manager
  * https://github.com/45Drives/cockpit-zfs-manager 

## General stuff
* Non-crap GUI / web interface (mobile compatible)
* Extend ansible playbooks for other distros (not just Debian 11 Bullseye)
* Flashable image for RPi
* Docker container
  * Target UnRAID, TruNAS/FreeNAS, etc
* Pre-baked VM images for popular VM tools (VirtualBox, VMWare, QEmu, etc) 
* WSL2 distribution for Windows10/11 users
  * "debian" distro exists, confirmed Debian 11 Bullseye
  * Waiting on Microsoft to allow WSL2 virtual switch in bridged mode for IPv4
