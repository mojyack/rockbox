application="yes"
target_id=103
modelname="sonynwza860"
target="SONY_NWZA860"
memory=16
bmp2rb_mono="$rootdir/tools/bmp2rb -f 0"
bmp2rb_native="$rootdir/tools/bmp2rb -f 4"
tool="cp"
output="rockbox.sony"
boottool="$rootdir/tools/scramble -add=a860"
bootoutput="bootloader-nwza860.sony"
appextra="gui:recorder:radio"
plugins=""
toolset=$genericbitmaptools
t_cpu="hosted"
t_manufacturer="sonynwz"
t_model="nwza860"
uname=$(uname)
sonynwzcc

