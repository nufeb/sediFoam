#!/bin/bash
cd ${0%/*} || exit 1 # Run from this directory

# Read the information of current directory.
# And collect information of the installation of LAMMPS from user.
echo "Installing lammpsFoam (for mac/linux).."
currentDir=$PWD
echo "Enter the directory of your LAMMPS and press [ENTER] "
echo -n "(default directory ./lammps-stable_23Jun2022_update4): "
read lammpsDir

# Determine if the directory of LAMMPS exists or not.
# If not, look for LAMMPS in the default directory.
if [ ! -d "$lammpsDir" ]
then
    echo "Directory NOT found! Use default directory instead."
    lammpsDir="$PWD/lammps-stable_23Jun2022_update4"
fi

cd $lammpsDir
lammpsDir=$PWD

echo "Directory of LAMMPS is: " $lammpsDir

echo "*******************************************"
echo "select the system you are running, then press enter"
echo "  1) Ubuntu14.x - Ubuntu16.x"
echo "  2) Ubuntu17.x - Ubuntu18.x" 
echo "  3) Centos"
echo "  4) Mac" 
echo "*******************************************"
read n

case $n in
  1) echo "You chose 1) Ubuntu14.x - Ubuntu16.x";;
  2) echo "You chose 2) Ubuntu17.x - Ubuntu18.x";;
  3) echo "You chose 3) Centos";;
  4) echo "You chose 4) Mac";;
  *) echo "Unknown option"; exit;;
esac


# Copy/link all the extra implementations
cd $lammpsDir/src
lammpsSRC=$PWD
echo $lammpsSRC
ln -sf $currentDir/interfaceToLammps/*.* . 
cd $lammpsDir/src/MAKE
ln -sf $currentDir/interfaceToLammps/MAKE/*.* .

# Make STUBS 
cd $lammpsDir/src/STUBS
make
cd $lammpsDir/src

# Make packages
make yes-SEDIFOAM
make yes-GRANULAR
make yes-KSPACE
make yes-MANYBODY
make yes-MOLECULE
make yes-FLD # lubrication
make yes-RIGID # freeze
make yes-MISC # deposit
make yes-VORONOI # ??

make -j4 shanghaimac mode=shlib
cd $FOAM_USER_APPBIN || exit 1
    
# Use different options according to different versions
if [ $n == 4 ];then 
    ln -sf $lammps_dir/src/liblammps_shanghaimac.so .
    cd $sedifoam_dir/lammpsFoam || exit 1
    touch Make/options
    echo "LAMMPS_DIR ="$lammps_src > Make/options
    cat Make/options-mac-openmpi >> Make/options
else
    ln -sf $lammps_dir/src/liblammps_shanghailinux.so .
    cd $sedifoam_dir/lammpsFoam || exit 1
    touch Make/options
    echo "LAMMPS_DIR ="$lammps_src > Make/options

    case $n in
	1) cat Make/options-ubuntu16-openmpi >> Make/options ;;
	2) cat Make/options-ubuntu18-openmpi >> Make/options ;;
	3) cat Make/options-linux-openmpi >> Make/options ;;
    esac

fi 

wmake libso dragModels 
wmake libso chPressureGrad 
wmake libso lammpsFoamTurbulenceModels
wmake 

