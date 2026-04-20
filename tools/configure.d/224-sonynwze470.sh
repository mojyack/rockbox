application="yes"
target_id=100
modelname="sonynwze470"
target="SONY_NWZE470"
memory=16
bmp2rb_mono="$rootdir/tools/bmp2rb -f 0"
bmp2rb_native="$rootdir/tools/bmp2rb -f 4"
tool="cp"
output="rockbox.sony"
boottool="$rootdir/tools/scramble -add=e470"
bootoutput="bootloader-nwze470.sony"
appextra="gui:recorder:radio"
plugins="yes"
toolset=$genericbitmaptools
t_cpu="hosted"
t_manufacturer="sonynwz"
t_model="nwze470"
uname=$(uname)
sonynwzcc

