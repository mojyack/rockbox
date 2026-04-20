target_id=53
modelname="sansafuze"
target="SANSA_FUZE"
memory=8
bmp2rb_mono="$rootdir/tools/bmp2rb -f 0"
bmp2rb_native="$rootdir/tools/bmp2rb -f 4"
tool="$rootdir/tools/scramble -add=fuze"
output="rockbox.sansa"
bootoutput="bootloader-fuze.sansa"
appextra="recorder:gui:radio"
plugins="yes"
toolset=$scramblebitmaptools
t_cpu="arm"
t_manufacturer="as3525"
t_model="sansa-fuze"
arm9tdmicc

