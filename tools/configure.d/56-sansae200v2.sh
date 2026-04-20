target_id=51
modelname="sansae200v2"
target="SANSA_E200V2"
memory=8
bmp2rb_mono="$rootdir/tools/bmp2rb -f 0"
bmp2rb_native="$rootdir/tools/bmp2rb -f 4"
tool="$rootdir/tools/scramble -add=e2v2"
output="rockbox.sansa"
bootoutput="bootloader-e200v2.sansa"
appextra="recorder:gui:radio"
plugins="yes"
toolset=$scramblebitmaptools
arm_thumb_boot=1
t_cpu="arm"
t_manufacturer="as3525"
t_model="sansa-e200v2"
arm9tdmicc

