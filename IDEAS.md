# Ideas to implement "one day"

## Commodore 64
* WiFi access point for C64-WiFi
* Disk emulator - Pi1541 - https://cbm-pi1541.firebaseapp.com/
* Tape emulator

## Audio player for tape based computers
* Push tape images over audio to compatible systems
  * Sega SC-3000 "bit" format
  * MSX "cas" format
  * MAME castool frontend - https://docs.mamedev.org/tools/castool.html

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

## ROM auditing
* https://github.com/frederic-mahe/Hardware-Target-Game-Database
* Symlinks/Hardlinks for deduplication (filesystem specific)

## Arcade Netboot
* PiForce - https://github.com/travistyoj/piforcetools
  * Supports Sega NAOMI, Chihiro, Triforce arcade hardware

## ISO / CHD
* ISO checksum tool
* ISO <-> CHD converter
* ISO CD/DVD burner (via USB CD-R/DVD-R)

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
  * Copy from RetroNAS to Floppy

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

