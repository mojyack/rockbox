target_id=33
modelname="mrobe100"
target="MROBE_100"
memory=32 # always
arm7tdmicc
tool="$rootdir/tools/scramble -mi4v2 -model=m100 -type=RBOS"
bmp2rb_mono="$rootdir/tools/bmp2rb -f 0"
bmp2rb_native="$rootdir/tools/bmp2rb -f 0"
bmp2rb_remotemono="$rootdir/tools/bmp2rb -f 0"
bmp2rb_remotenative="$rootdir/tools/bmp2rb -f 0"
output="rockbox.mi4"
appextra="recorder:gui:radio"
plugins="yes"
boottool="$rootdir/tools/scramble -mi4v2 -model=m100 -type=RBBL"
bootoutput="pp5020.mi4"
# toolset is the tools within the tools directory that we build for
# this particular target.
toolset=$scramblebitmaptools
# architecture, manufacturer and model for the target-tree build
t_cpu="arm"
t_soc="pp"
t_manufacturer="olympus"
t_model="mrobe-100"

