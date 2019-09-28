# !bin/sh
# This script renames the output of foamToVTK -useTimeName to a causal sequence of integer naming, i.e. 0 1 2 3 4 etc.
# For use with post-processing of moored objects, to make time sync in the viewer. 
# In combination with moodyPost.x -vtk -timeList tList.txt command for the cables

# Usage ./makeSequential.sh <nameOfVTKGroupInVTKFolder>
# Note: for patches the nameOfVTKGroupInVTKFolder has to be <name>/<name> as that is how foamToVTK stores it.

# Input: 
folder=VTK
caseName="$1"

# Collect list of names
pushd $folder

# ls ${caseName}_*.vtk | sed -E 's/\.vtk//'  > nameList

ls -v ${caseName}_*.vtk > nameList
fNames=$(cat nameList)
ii=0
for f in $fNames
do
	mv $f ${caseName}_${ii}.vtk.tmp
	ii=$((ii+1))		
done

# remove .tmp extension
rename '.tmp' '' *.tmp;

# Clean tmp nameList.
rm nameList
popd
