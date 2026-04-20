application="yes"
target_id=73
modelname="sdlapp"
target="SDLAPP"
app_set_paths
app_set_lcd_size
memory=8
uname=$(uname)
simcc "sdl-app"
tool="cp "
boottool="cp "
bmp2rb_mono="$rootdir/tools/bmp2rb -f 0"
bmp2rb_native="$rootdir/tools/bmp2rb -f 9"
output="rockbox"
bootoutput="rockbox"
appextra="recorder:gui:radio"
plugins="yes"
# architecture, manufacturer and model for the target-tree build
t_cpu="hosted"
t_manufacturer="sdl"
t_model="app"

