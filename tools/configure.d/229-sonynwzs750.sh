application="yes"
target_id=104
modelname="sonynwzs750"
target="SONY_NWZS750"
memory=16
bmp2rb_mono="$rootdir/tools/bmp2rb -f 0"
bmp2rb_native="$rootdir/tools/bmp2rb -f 4"
tool="cp"
output="rockbox.sony"
boottool="$rootdir/tools/scramble -add=s750"
bootoutput="bootloader-nwzs750.sony"
appextra="gui:recorder:radio"
plugins="yes"
toolset=$genericbitmaptools
t_cpu="hosted"
t_manufacturer="sonynwz"
t_model="nwzs750"
uname=$(uname)
sonynwzcc

