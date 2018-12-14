install:
	install -m 0755 synchome.sh $(PREFIX)/bin/synchome
	install -m 0755 clean-union-tmpfs.sh $(PREFIX)/bin/clean-union-tmpfs

install-config-file:
	cp home-tmpfs-ignore ~/.config
