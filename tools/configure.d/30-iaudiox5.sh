target_id=12
modelname="iaudiox5"
target="IAUDIO_X5"
memory=16 # always
coldfirecc
tool="$rootdir/tools/scramble -add=iax5"
boottool="$rootdir/tools/scramble -iaudiox5"
bmp2rb_mono="$rootdir/tools/bmp2rb -f 0"
bmp2rb_native="$rootdir/tools/bmp2rb -f 4"
bmp2rb_remotemono="$rootdir/tools/bmp2rb -f 0"
bmp2rb_remotenative="$rootdir/tools/bmp2rb -f 7"
output="rockbox.iaudio"
bootoutput="x5_fw.bin"
appextra="recorder:gui:radio"
plugins="yes"
# toolset is the tools within the tools directory that we build for
# this particular target.
toolset="$iaudiobitmaptools"
# architecture, manufacturer and model for the target-tree build
t_cpu="coldfire"
t_manufacturer="iaudio"
t_model="x5"

