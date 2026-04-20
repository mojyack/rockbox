target_id=50
modelname="sansaclip"
target="SANSA_CLIP"
memory=2
bmp2rb_mono="$rootdir/tools/bmp2rb -f 0"
bmp2rb_native="$bmp2rb_mono"
tool="$rootdir/tools/scramble -add=clip"
output="rockbox.sansa"
bootoutput="bootloader-clip.sansa"
appextra="recorder:gui:radio"
plugins="yes"
toolset=$scramblebitmaptools
t_cpu="arm"
t_manufacturer="as3525"
t_model="sansa-clip"
sysfont="08-Rockfont"
if [ "$ARG_ARM_THUMB" != 0 ]; then ARG_ARM_THUMB=1; fi
arm9tdmicc

