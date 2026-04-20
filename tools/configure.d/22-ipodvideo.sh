target_id=15
modelname="ipodvideo"
target="IPOD_VIDEO"
memory=64 # always. This is reduced at runtime if needed
arm7tdmicc
tool="$rootdir/tools/scramble -add=ipvd"
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
t_soc="pp"
t_manufacturer="ipod"
t_model="video"

