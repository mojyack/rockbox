target_id=107
modelname="ihifi770c"
target="IHIFI770C"
memory=16
arm7ejscc
tool="$rootdir/tools/scramble -rkw -modelnum=97"
bmp2rb_mono="$rootdir/tools/bmp2rb -f 0"
bmp2rb_native="$rootdir/tools/bmp2rb -f 4"
output="rockbox.rkw"
bootoutput="bootloader.rkw"
appextra="recorder:gui"
plugins="yes"
# toolset is the tools within the tools directory that we build for
# this particular target.
toolset="$genericbitmaptools"
# architecture, manufacturer and model for the target-tree build
t_cpu="arm"
t_manufacturer="rk27xx"
t_model="ihifi2"

