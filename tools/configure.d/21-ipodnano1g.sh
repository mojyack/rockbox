target_id=14
modelname="ipodnano1g"
target="IPOD_NANO"
memory=32 # always
arm7tdmicc
tool="$rootdir/tools/scramble -add=nano"
bmp2rb_mono="$rootdir/tools/bmp2rb -f 0"
bmp2rb_native="$rootdir/tools/bmp2rb -f 5"
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
t_model="nano"

