target_id=24
modelname="iriverh10_5gb"
target="IRIVER_H10_5GB"
memory=32 # always
arm7tdmicc
tool="$rootdir/tools/scramble -mi4v2 -model=h105 -type=RBOS"
bmp2rb_mono="$rootdir/tools/bmp2rb -f 0"
bmp2rb_native="$rootdir/tools/bmp2rb -f 5"
output="rockbox.mi4"
appextra="recorder:gui:radio"
plugins="yes"
boottool="$rootdir/tools/scramble -mi4v2 -model=h105 -type=RBBL"
bootoutput="H10.mi4"
# toolset is the tools within the tools directory that we build for
# this particular target.
toolset=$scramblebitmaptools
# architecture, manufacturer and model for the target-tree build
t_cpu="arm"
t_soc="pp"
t_manufacturer="iriver"
t_model="h10"

