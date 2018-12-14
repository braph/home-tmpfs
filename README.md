# home-tmpfs
Keep a tmpfs layer before your home directory


# Setup

* Setup unionfs (see fstab)

* Install ignore file:
   `make install-config-file`

* Install scripts (or copy scripts by manually)
   `sudo make install`

# Run

* Dry sync (see what would be copied):
   `sudo synchome --dry --log-file /tmp/sync.log --exclude-file ~/.config/home-tmpfs-ignore --union-dir /home --perm-dir /.home.perm`

* Maybe change your exclude file if you see some stuff that shoul'd not be kept.

* Non-dry sync:
   `sudo synchome --exclude-file ~/.config/home-tmpfs-ignore --union-dir /home --perm-dir /.home.perm`

* Generate shell script that remove files from tmpfs that have been copied to persistant storage
   `sudo clean-union-tmpfs.sh /.home.tmp /.home.perm > /tmp/clean.sh`

* Call script
   `sudo sh /tmp/clean.sh`
