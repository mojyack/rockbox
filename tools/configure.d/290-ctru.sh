target_id=122
application="yes"
modelname="ctru"
app_type="ctru-app"
target="CTRU"
memory=16
uname=$(uname)
devkitarmcc
tool="cp "
boottool="cp "
bmp2rb_mono="$rootdir/tools/bmp2rb -f 0"
bmp2rb_native="$rootdir/tools/bmp2rb -f 4"
output="rockbox.elf"
bootoutput="rockbox"
appextra="recorder:gui"
plugins="yes"
t_cpu="hosted"
t_manufacturer="ctru"
t_model="app"

