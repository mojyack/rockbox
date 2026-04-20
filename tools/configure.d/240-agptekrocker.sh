application="yes"
app_type="hibyos"
target_id=97
modelname="agptekrocker"
target="AGPTEK_ROCKER"
memory=8
tool="cp "
boottool="cp "
bmp2rb_mono="$rootdir/tools/bmp2rb -f 0"
bmp2rb_native="$rootdir/tools/bmp2rb -f 10"
output="rockbox.rocker"
bootoutput="bootloader.rocker"
appextra="recorder:gui:hosted"
plugins="yes"
# architecture, manufacturer and model for the target-tree build
t_cpu="hosted"
t_manufacturer="agptek"
t_model="rocker"
mipsellinuxcc

