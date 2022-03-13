@echo off
set VBMANAGER="C:\Program Files\Oracle\VirtualBox\VBoxManage.exe"
set VBVM="C:\Program Files\Oracle\VirtualBox\VirtualBoxVM.exe"

%VBMANAGER% createvm --name %1 --ostype Debian --register
%VBMANAGER% modifyvm %1 --memory 8096
%VBMANAGER% modifyvm %1 --longmode on

%VBMANAGER% modifyvm %1 --audio none

%VBMANAGER% modifyvm %1 --bridgeadapter1 "Intel(R) Ethernet Connection (2) I218-V"
%VBMANAGER% modifyvm %1 --nic1 bridged

%VBMANAGER% createhd --filename c:\tmp\%1.vdi --size 10000 --format VDI --variant Fixed

%VBMANAGER% storagectl %1 --name "SATA Controller" --add sata --controller IntelAhci
%VBMANAGER% storageattach %1 --storagectl "SATA Controller" --port 0 --device 0 --type hdd --medium c:\tmp\%1.vdi

%VBMANAGER% storagectl %1 --name "IDE Controller" --add ide --controller PIIX4
%VBMANAGER% storageattach %1 --storagectl "IDE Controller" --port 1 --device 0 --type dvddrive --medium c:\tmp\retronas.iso

%VBMANAGER% modifyvm %1 --boot1 dvd
%VBMANAGER% modifyvm %1 --boot2 disk

%VBVM% --startvm %1
