target_id=60
modelname="sansaclipv2"
target="SANSA_CLIPV2"
memory=8
bmp2rb_mono="$rootdir/tools/bmp2rb -f 0"
bmp2rb_native="$bmp2rb_mono"
tool="$rootdir/tools/scramble -add=clv2"
output="rockbox.sansa"
bootoutput="bootloader-clipv2.sansa"
appextra="recorder:gui:radio"
plugins="yes"
toolset=$scramblebitmaptools
t_cpu="arm"
t_manufacturer="as3525"
t_model="sansa-clipv2"
sysfont="08-Rockfont"
arm926ejscc

