application="yes"
target_id=94
modelname="ibassodx50"
target="DX50"
app_type="android_ndk"
lcd_orientation="landscape"
# Actually 408260kB
memory=192
uname=$(uname)
androidndkcc 16 armeabi "-mcpu=cortex-a9 -mfpu=neon-fp16 -mfloat-abi=softfp"
tool="cp "
boottool="cp "
bmp2rb_mono="$rootdir/tools/bmp2rb -f 0"
bmp2rb_native="$rootdir/tools/bmp2rb -f 4"
output="rockbox"
bootoutput="rockbox"
appextra="recorder:gui:hosted"
plugins="yes"
tinyalsa="yes"
# architecture, manufacturer and model for the target-tree build
t_cpu="hosted"
t_manufacturer="ibasso"
t_model="dx50"

