# !bin/sh
# Input:
folder=VTK
caseName=floatingObject
patchNames='floatingObject' 

#Dont touch:

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

for p in $patchNames
do
	ls -v ${p}/${p}_*.vtk > nameList
	fNames=$(cat nameList)
	ii=0
	for f in $fNames
	do
		mv $f ${p}/${p}_$ii.vtk.tmp
		ii=$((ii+1))
	done
	# Remove .tmp extension.
	rename '.tmp' '' ${p}/*.tmp;
done


# Clean tmp nameList.
rm nameList
popd
