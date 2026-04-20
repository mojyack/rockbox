application="yes"
target_id=74
modelname="androidx86"
target="ANDROID"
app_type="android"
app_set_lcd_size
sharedir="/data/data/org.rockbox/app_rockbox/rockbox"
bindir="/data/data/org.rockbox/lib"
libdir="/data/data/org.rockbox/app_rockbox"
memory=8
uname=$(uname)
androidcc 19 x86
tool="cp "
boottool="cp "
bmp2rb_mono="$rootdir/tools/bmp2rb -f 0"
bmp2rb_native="$rootdir/tools/bmp2rb -f 4"
output="librockbox.so"
bootoutput="librockbox.so"
appextra="recorder:gui:radio:hosted/android"
plugins="yes"
# architecture, manufacturer and model for the target-tree build
t_cpu="hosted"
t_manufacturer="android"
t_model="app"

