application="yes"
app_type="fiio"
target_id=112
modelname="fiiom3klinux"
target="FIIO_M3K_LINUX"
memory=16 # XXX Can probably go over 32?
tool="cp "
boottool="cp "
bmp2rb_mono="$rootdir/tools/bmp2rb -f 0"
bmp2rb_native="$rootdir/tools/bmp2rb -f 4"
output="rockbox.m3k"
bootoutput="bootloader.m3k"
appextra="recorder:gui:hosted"
plugins="yes"
# architecture, manufacturer and model for the target-tree build
t_cpu="hosted"
t_manufacturer="fiio"
t_model="m3k"
mipsellinuxcc
sysfontbl="16-Terminus"

