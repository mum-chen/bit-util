
build:
	@lua install/build.lua `pwd`

.PHONY: install force_install
install:bits.sh
	sudo ln -s `pwd`/bits.sh  /usr/bin/bits

force_install:
	sudo ln -sf `pwd`/bits.sh  /usr/bin/bits

.PHONY: clean
clean:
	-@ rm bits.sh -f
	- sudo unlink /usr/bin/bits
