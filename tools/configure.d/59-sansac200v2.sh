target_id=55
modelname="sansac200v2"
target="SANSA_C200V2"
memory=2 # as per OF diagnosis mode
bmp2rb_mono="$rootdir/tools/bmp2rb -f 0"
bmp2rb_native="$rootdir/tools/bmp2rb -f 4"
tool="$rootdir/tools/scramble -add=c2v2"
output="rockbox.sansa"
bootoutput="bootloader-c200v2.sansa"
appextra="recorder:gui:radio"
plugins="yes"
# toolset is the tools within the tools directory that we build for
# this particular target.
toolset=$scramblebitmaptools
# architecture, manufacturer and model for the target-tree build
t_cpu="arm"
t_manufacturer="as3525"
t_model="sansa-c200v2"
if [ "$ARG_ARM_THUMB" != 0 ]; then ARG_ARM_THUMB=1; fi
arm9tdmicc

