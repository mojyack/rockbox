target_id=119
modelname="echor1"
target="ECHO_R1"
memory=32
armcortexm7cc
appextra="recorder:gui"
plugins="no"
tool="cp "
boottool="cp "
output="rockbox.echo"
bootoutput="bootloader.echo"
sysfontbl="16-Terminus"
sysfont="14-Rockbox-Mix"
# toolset is the tools within the tools directory that we build for
# this particular target.
toolset="$genericbitmaptools scramble uclpack reggen"
bmp2rb_mono="$rootdir/tools/bmp2rb -f 0"
bmp2rb_native="$rootdir/tools/bmp2rb -f 4"
# architecture, manufacturer and model for the target-tree build
t_cpu="arm"
t_manufacturer="stm32"
t_model="echoplayer"
# generate debug symbols by default; these will be present in the
# initial '.elf' file but will be stripped from the target binary.
GCCOPTS="-g $GCCOPTS"
# set page size to 4k to guarantee reasonable on-disk alignment,
# which improves disk read speed; on ARM binutils defaults to 64k
# which adds quite a bit of unnecessary padding.
GCCOPTS="-Wl,-z,max-page-size=4096 $GCCOPTS"
USE_ELF="yes"

