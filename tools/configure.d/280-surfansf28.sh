target_id=120
application="yes"
app_type="hibyos"
modelname="surfansf28"
target="SURFANS_F28"
memory=32 # 64 total!
mipsellinuxcc
tool="cp "
boottool="cp "
bmp2rb_mono="$rootdir/tools/bmp2rb -f 0"
bmp2rb_native="$rootdir/tools/bmp2rb -f 10"
output="rockbox.f28"
bootoutput="bootloader.f28"
appextra="recorder:gui:hosted"
plugins="no"
# architecture, manufacturer and model for the target-tree build
t_cpu="hosted"
t_manufacturer="surfans"
t_model="f28"
sysfontbl="16-Terminus"

