target_id=10
modelname="iriverh300"
target="IRIVER_H300"
memory=32 # always
coldfirecc
tool="$rootdir/tools/scramble -add=h300"
bmp2rb_mono="$rootdir/tools/bmp2rb -f 0"
bmp2rb_native="$rootdir/tools/bmp2rb -f 4"
bmp2rb_remotemono="$rootdir/tools/bmp2rb -f 0"
bmp2rb_remotenative="$rootdir/tools/bmp2rb -f 0"
output="rockbox.iriver"
bootoutput="bootloader.iriver"
appextra="recorder:gui:radio"
flash="$pwd/rombox.iriver"
plugins="yes"
# toolset is the tools within the tools directory that we build for
# this particular target.
toolset=$iriverbitmaptools
t_cpu="coldfire"
t_manufacturer="iriver"
t_model="h300"

