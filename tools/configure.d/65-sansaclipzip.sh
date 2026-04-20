target_id=68
modelname="sansaclipzip"
target="SANSA_CLIPZIP"
memory=8 # not sure
bmp2rb_mono="$rootdir/tools/bmp2rb -f 0"
bmp2rb_native="$rootdir/tools/bmp2rb -f 4"
tool="$rootdir/tools/scramble -add=clzp"
output="rockbox.sansa"
bootoutput="bootloader-clipzip.sansa"
appextra="recorder:gui:radio"
plugins="yes"
toolset=$scramblebitmaptools
t_cpu="arm"
t_manufacturer="as3525"
t_model="sansa-clipzip"
arm926ejscc

