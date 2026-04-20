target_id=124
application="yes"
app_type="hibyos"
modelname="hibyr1"
target="HIBY_R1"
memory=16 # The device has 64mb but let's make sure it still boots with things in the background
mipsellinuxcc
tool="cp "
boottool="cp "
bmp2rb_mono="$rootdir/tools/bmp2rb -f 0"
bmp2rb_native="$rootdir/tools/bmp2rb -f 4"
output="rockbox.r1"
bootoutput="bootloader.r1"
appextra="recorder:gui:hosted"
plugins="yes"
# architecture, manufacturer and model for the target-tree build
# These align with
t_cpu="hosted"
t_manufacturer="hiby"
t_model="r1"
sysfontbl="24-Terminus"
sysfont="20-Terminus"

