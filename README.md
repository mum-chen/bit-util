INSTALL:
======
first install
-------------
```
make prep && make && make install
```

detail
------
make prep
	prep submodule

make
	genrate the shell script

make install
	link shell script to /usr/bin


TODO:
=====
 - This version only output with binary format,
   the next step is providing more output style.

 - Add some way to distinct the number after "-",
   such like negative number( -3, -10, -11);

 - Add a simple way to install this program.
     - submodule pull-permission
     - auto-gen bits.sh
