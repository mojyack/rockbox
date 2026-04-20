application="yes"
target_id=101
modelname="sonynwza10"
target="SONY_NWZA10"
memory=16
bmp2rb_mono="$rootdir/tools/bmp2rb -f 0"
bmp2rb_native="$rootdir/tools/bmp2rb -f 4"
tool="cp"
output="rockbox.sony"
boottool="$rootdir/tools/scramble -add=a10"
bootoutput="bootloader-nwza10.sony"
appextra="gui:recorder:radio"
plugins="yes"
toolset=$genericbitmaptools
t_cpu="hosted"
t_manufacturer="sonynwz"
t_model="nwza10"
uname=$(uname)
sonynwzcc

