show:
	echo 'Run "make install" as root to install program!'
run:
	bash identicon.sh
install:
	sudo cp identicon.sh /usr/bin/identicon
	sudo chmod +x /usr/bin/identicon
uninstall:
	sudo rm /usr/bin/identicon
build: 
	sudo make build-deb;
build-deb:
	mkdir -p debian;
	mkdir -p debian/DEBIAN;
	mkdir -p debian/usr;
	mkdir -p debian/usr/bin;
	# make post and pre install scripts have the correct permissions
	chmod 775 debdata/*
	# copy over the binary
	cp -vf identicon.sh ./debian/usr/bin/identicon
	# make the program executable
	chmod +x ./debian/usr/bin/identicon
	# start the md5sums file
	md5sum ./debian/usr/bin/identicon > ./debian/DEBIAN/md5sums
	# create md5 sums for all the config files transfered over
	sed -i.bak 's/\.\/debian\///g' ./debian/DEBIAN/md5sums
	rm -v ./debian/DEBIAN/md5sums.bak
	cp -rv debdata/. debian/DEBIAN/
	# find the size of the package 
	du -sx --exclude DEBIAN ./debian/ | sed "s/[abcdefghijklmnopqrstuvwxyz\ /.]//g" > packageSize.txt
	dpkg-deb --build debian
	cp -v debian.deb identicon.deb
	rm -v debian.deb
	rm -rv debian
