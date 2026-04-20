target_id=57
modelname="samsungyh820"
target="SAMSUNG_YH820"
memory=32 # always
arm7tdmicc
tool="$rootdir/tools/scramble -mi4v2 -model=y820 -type=RBOS"
bmp2rb_mono="$rootdir/tools/bmp2rb -f 0"
bmp2rb_native="$rootdir/tools/bmp2rb -f 4"
output="rockbox.mi4"
appextra="recorder:gui:radio"
plugins="yes"
boottool="$rootdir/tools/scramble -mi4v2 -model=y820 -type=RBBL"
bootoutput="FW_YH820.mi4"
# toolset is the tools within the tools directory that we build for
# this particular target.
toolset=$scramblebitmaptools
# architecture, manufacturer and model for the target-tree build
t_cpu="arm"
t_soc="pp"
t_manufacturer="samsung"
t_model="yh820"

