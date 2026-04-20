target_id=78
modelname="rk27generic"
target="RK27_GENERIC"
memory=16 # always
arm7ejscc
tool="$rootdir/tools/scramble -rkw -modelnum=73"
bmp2rb_mono="$rootdir/tools/bmp2rb -f 0"
bmp2rb_native="$rootdir/tools/bmp2rb -f 4"
output="rockbox.rkw"
bootoutput="bootloader.rkw"
appextra="recorder:gui:radio"
plugins=""
# toolset is the tools within the tools directory that we build for
# this particular target.
toolset="$genericbitmaptools"
# architecture, manufacturer and model for the target-tree build
t_cpu="arm"
t_manufacturer="rk27xx"
t_model="rk27generic"

