target_id=52
modelname="sansam200v4"
target="SANSA_M200V4"
memory=2
bmp2rb_mono="$rootdir/tools/bmp2rb -f 0"
bmp2rb_native="$bmp2rb_mono"
tool="$rootdir/tools/scramble -add=m2v4"
output="rockbox.sansa"
bootoutput="bootloader-m200v4.sansa"
appextra="recorder:gui:radio"
plugins="yes"
toolset=$scramblebitmaptools
t_cpu="arm"
t_manufacturer="as3525"
t_model="sansa-m200v4"
sysfont="08-Rockfont"
if [ "$ARG_ARM_THUMB" != 0 ]; then ARG_ARM_THUMB=1; fi
arm9tdmicc

