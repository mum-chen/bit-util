# into PROGRAM_PATH
EXAMPLE_PATH=`dirname $0`
cd $EXAMPLE_PATH
cd ..


# echo "./bits-tool 0x7e h -w 8 -s 100,2"
# ./bits-tool 0x7e h -w 8 -s 100,2

echo "./bits-tool 0x7e h -w 8 -s 100,2 01,3"
./bits-tool 0x7e h -w 8 -s 100,2 01,3


# echo "./bits-tool 0xff h -w 8 -s 0,2"
# ./bits-tool 0xff h -w 8 -s 0,2
