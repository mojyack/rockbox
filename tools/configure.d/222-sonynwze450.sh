application="yes"
target_id=96
modelname="sonynwze450"
target="SONY_NWZE450"
memory=16
bmp2rb_mono="$rootdir/tools/bmp2rb -f 0"
bmp2rb_native="$rootdir/tools/bmp2rb -f 4"
tool="cp"
output="rockbox.sony"
boottool="$rootdir/tools/scramble -add=e450"
bootoutput="bootloader-nwze450.sony"
appextra="gui:recorder:radio"
plugins="yes"
toolset=$genericbitmaptools
t_cpu="hosted"
t_manufacturer="sonynwz"
t_model="nwze450"
uname=$(uname)
sonynwzcc

