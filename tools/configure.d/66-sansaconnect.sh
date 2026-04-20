target_id=81
modelname="sansaconnect"
target="SANSA_CONNECT"
memory=64
bmp2rb_mono="$rootdir/tools/bmp2rb -f 0"
bmp2rb_native="$rootdir/tools/bmp2rb -f 4"
tool="$rootdir/tools/scramble -add=conn"
output="rockbox.sansa"
bootoutput="bootloader-connect.sansa"
appextra="recorder:gui"
plugins="yes"
toolset=$scramblebitmaptools
t_cpu="arm"
t_manufacturer="tms320dm320"
t_model="sansa-connect"
arm926ejscc

