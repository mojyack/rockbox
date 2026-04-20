target_id=66
modelname="sansaclipplus"
target="SANSA_CLIPPLUS"
memory=8
bmp2rb_mono="$rootdir/tools/bmp2rb -f 0"
bmp2rb_native="$bmp2rb_mono"
tool="$rootdir/tools/scramble -add=cli+"
output="rockbox.sansa"
bootoutput="bootloader-clipplus.sansa"
appextra="recorder:gui:radio"
plugins="yes"
toolset=$scramblebitmaptools
t_cpu="arm"
t_manufacturer="as3525"
t_model="sansa-clipplus"
sysfont="08-Rockfont"
arm926ejscc

