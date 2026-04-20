target_id=62
modelname="ipodnano2g"
target="IPOD_NANO2G"
memory=32 # always
arm940tcc
tool="$rootdir/tools/scramble -add=nn2g"
bmp2rb_mono="$rootdir/tools/bmp2rb -f 0"
bmp2rb_native="$rootdir/tools/bmp2rb -f 4"
output="rockbox.ipod"
appextra="recorder:gui:radio"
plugins="yes"
bootoutput="bootloader-$modelname.ipod"
# toolset is the tools within the tools directory that we build for
# this particular target.
toolset=$ipodbitmaptools
# architecture, manufacturer and model for the target-tree build
t_cpu="arm"
t_manufacturer="s5l8700"
t_model="ipodnano2g"

