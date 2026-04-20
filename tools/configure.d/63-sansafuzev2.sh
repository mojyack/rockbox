target_id=68
modelname="sansafuzev2"
target="SANSA_FUZEV2"
memory=8 # not sure
bmp2rb_mono="$rootdir/tools/bmp2rb -f 0"
bmp2rb_native="$rootdir/tools/bmp2rb -f 5"
tool="$rootdir/tools/scramble -add=fuz2"
output="rockbox.sansa"
bootoutput="bootloader-fuzev2.sansa"
appextra="recorder:gui:radio"
plugins="yes"
toolset=$scramblebitmaptools
t_cpu="arm"
t_manufacturer="as3525"
t_model="sansa-fuzev2"
arm926ejscc

