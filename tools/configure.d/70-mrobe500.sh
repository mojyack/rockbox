target_id=36
modelname="mrobe500"
target="MROBE_500"
memory=64 # always
arm926ejscc
tool="$rootdir/tools/scramble -add=m500"
bmp2rb_mono="$rootdir/tools/bmp2rb -f 0"
bmp2rb_native="$rootdir/tools/bmp2rb -f 8"
bmp2rb_remotemono="$rootdir/tools/bmp2rb -f 0"
bmp2rb_remotenative="$rootdir/tools/bmp2rb -f 0"
output="rockbox.mrobe500"
appextra="recorder:gui:radio"
plugins="yes"
toolset=$gigabeatbitmaptools
boottool="cp "
bootoutput="rockbox.mrboot"
# architecture, manufacturer and model for the target-tree build
t_cpu="arm"
t_manufacturer="tms320dm320"
t_model="mrobe-500"

