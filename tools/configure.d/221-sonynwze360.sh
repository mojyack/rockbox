target_id=89
modelname="sonynwze360"
target="SONY_NWZE360"
memory=32
bmp2rb_mono="$rootdir/tools/bmp2rb -f 0"
bmp2rb_native="$rootdir/tools/bmp2rb -f 4"
tool="$rootdir/tools/scramble -add=e360"
output="rockbox.sony"
bootoutput="bootloader-nwze360.sony"
appextra="gui:recorder:radio"
plugins="yes"
toolset=$scramblebitmaptools
t_cpu="arm"
t_manufacturer="imx233"
t_model="sony-nwz"
arm926ejscc

