target_id=37
modelname="iaudiom3"
target="IAUDIO_M3"
memory=16 # always
coldfirecc
tool="$rootdir/tools/scramble -add=iam3"
boottool="$rootdir/tools/scramble -iaudiom3"
bmp2rb_mono="$rootdir/tools/bmp2rb -f 0"
bmp2rb_native="$rootdir/tools/bmp2rb -f 7"
output="rockbox.iaudio"
bootoutput="cowon_m3.bin"
appextra="recorder:gui:radio"
plugins="yes"
# toolset is the tools within the tools directory that we build for
# this particular target.
toolset="$iaudiobitmaptools"
# architecture, manufacturer and model for the target-tree build
t_cpu="coldfire"
t_manufacturer="iaudio"
t_model="m3"

