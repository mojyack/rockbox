target_id=118
modelname="ipodnano4g"
blonly="yes"
target="IPOD_NANO4G"
memory=32 # always
arm1176jzscc
tool="$rootdir/tools/scramble -add=nn4g"
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
t_manufacturer="s5l8702"
t_model="ipodnano4g"

