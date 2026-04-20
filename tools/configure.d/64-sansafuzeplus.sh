target_id=80
modelname="sansafuzeplus"
target="SANSA_FUZEPLUS"
memory=64
bmp2rb_mono="$rootdir/tools/bmp2rb -f 0"
bmp2rb_native="$rootdir/tools/bmp2rb -f 4"
tool="$rootdir/tools/scramble -add=fuz+"
output="rockbox.sansa"
bootoutput="bootloader-fuzeplus.sansa"
appextra="gui:recorder:radio"
plugins="yes"
toolset=$scramblebitmaptools
t_cpu="arm"
t_manufacturer="imx233"
t_model="sansa-fuzeplus"
arm926ejscc

