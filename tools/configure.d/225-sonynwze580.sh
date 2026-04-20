application="yes"
target_id=98
modelname="sonynwze580"
target="SONY_NWZE580"
memory=16
bmp2rb_mono="$rootdir/tools/bmp2rb -f 0"
bmp2rb_native="$rootdir/tools/bmp2rb -f 4"
tool="cp"
output="rockbox.sony"
boottool="$rootdir/tools/scramble -add=e580"
bootoutput="bootloader-nwze580.sony"
appextra="gui:recorder:radio"
plugins="yes"
toolset=$genericbitmaptools
t_cpu="hosted"
t_manufacturer="sonynwz"
t_model="nwze580"
uname=$(uname)
sonynwzcc

