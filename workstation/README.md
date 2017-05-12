# OpenBSD Workstation Setup

## Installation

### Preliminary Notes

* use full disk encryption using password or USB keydisk using softraid
* target disk is sd0
* usb keydisk is sd2
* installation media is sd1
* created softraid disk will be sd3

### Prepare Keydisk

If using USB keydisk, create multiple RAID partitions, 1M each, for keys. One key per system. Rest of the disk can be used for MSDOS
 `i` partition. Example disklabel:

```sh
fdisk -iy sd2
disklabel -E sd2
a a
1M
RAID
a b
1M
RAID
#... continue adding RAID partitions as necessary
a i
MSDOS
q
newfs_msdos sd2i
```

### Install Steps

* Boot install media and type `S` - shell
* Find out disk names `sysctl hw.disknames`
* Make missing device nodes

```sh
cd /dev
sh MAKEDEV sd1
sh MAKEDEV sd2
sh MAKEDEV sd3
```

* Initialize target disk

```sh
dd if=/dev/zero of=/dev/rsd0c bs=1m count=1
fdisk -iy sd0
```

* Add disklabel for encrypted data: `disklabel -E sd0`. Add new partition `a` of type `RAID`
* Make encrypted softraid

```sh
bioctl -c C -l /dev/sd0a softraid0 # creates sd3 softraid volume
dd if=/dev/zero of=/dev/rsd3c bs=1m count=1
```

if using USB keydisk, run

```sh
bioctl -c C -l /dev/sd0a -k /dev/sd2b softraid0 # use proper disklabel from sd2
```

* Install OpenBSD: `install`. Use `sd3` as root device. Use default partitioning scheme with swap on sd3b.
* Reboot after install.

## Post Install Setup

### System

* /etc/fstab
  * add `noatime` option on all partitions except swap
  * add `softdep` option to home
* /etc/login.conf
  * increase `datasize-max` and `datasize-cur` in `staff` and `default` sections to value RAM - 1GB.
  * increase `openfiles-max` and `openfiles-cur` in `default` to 4096 on powerful machine
  * run `cap_mkdb /etc/login.conf`

* /etc/sysctl.conf

```
vm.swapencrypt.enable=0
```

* /etc/doas.conf

```
permit persist :wheel
permit nopass keepenv root
```

* /etc/rc.conf.local - basic: start apm, hotplugd and xdm. Other configs will be added after application installation.

```
apmd_flags=-A
hotplugd_flags=
multicast=YES
pkg_scripts=cupsd messagebus avahi_daemon gdm
```

* /etc/mixerctl.conf

```
outputs.master=200,200
```

* /etc/installurl

Should contain URL to OpenBSD mirror. Create manually if not existing

* /etc/mail/aliases

```
root: $USERNAME
```

Run `newaliases` afterwards.

### Applications

* Install

```sh
# desktop
pkg_add firefox chromium mplayer libreoffice anacron filezilla hotplug-diskmount ubuntu-fonts gvfs-smb consolekit2 xfce xfce-extras gimp inkscape shotwell
# tools
pkg_add git mercurial subversion postgresql-server unzip jdk go node
# money
pkg_add vpnc openvpn rdesktop bash duplicity
```

* Configure apps after reading `/usr/local/share/doc/pkg-readmes/`
  * read setup for anacron (set anacrontab and modify roots crontab)
  * run systemwide messagebus for xfce
  * read setup for vpnc (sysctls needed)
  * read setup for hotplug-diskmount (config in /etc needed)

### User

Download all files from this repository to $HOME. Use what makes sense.
**Fix name/email in .gitconfig**.

### Updates

#### System

* **Current** - Use `upgrade/download.sh` from this repo to download distribution and upgrade booting from `bsd.rd`.
* **Release** - Use syspatch (add `syspatch -c` to crontab/anacrontab).

#### Applications

* **Current** - `pkg_add -u && pkg_delete -a`
* **Release**
  * ([M:TIER?](https://stable.mtier.org/))
  * Firefox stable packages: 
    ```
    cd /etc/signify
    doas ftp https://packages.rhaalovely.net/landry-mozilla-pkg.pub
    doas env PKG_PATH=https://packages.rhaalovely.net/pub/OpenBSD/6.1/packages/$(arch -s) pkg_add -u firefox
    ```
