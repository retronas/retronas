# Ideas to implement by somebody brave

## FTP client
* Something web based preferably
  * Allow push from RetroNAS to devices like modded Classic XBox, XBox 360

## ROM auditing
* https://github.com/frederic-mahe/Hardware-Target-Game-Database
* Symlinks/Hardlinks for deduplication (filesystem specific)

## ISO tools
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

## Dialup
* DreamPi - https://github.com/Kazade/dreampi
  * Test with other devices that expect dialup

## Serial port
* USB to RS232/DB9
* RPi GPIO to RS232/DB9
* ppp support with dhcp
  * Test with null-modem compatible OSes - DOS, Win3.x, Win9x, Amiga, etc
  * RetroPi access over serial
  * Internet access over serial (via WebOne)

## DHCP / DNS / PXE
* dnsmasq or something similar and simple
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
