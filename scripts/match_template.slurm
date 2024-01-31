#!/usr/bin/env bash
#
# Match template to a single micrograph
#
# The stdout (-o) and stderr (-e) files will be written to
# THE SUBMISSION DIRECTORY with names that follow the given templates.
#SBATCH -o outrunLog.%j.%A.%a.%N.out
#SBATCH -e errrunLog.%j.%A.%a.%N.err
# slurm settings
#SBATCH -p gpu
#SBATCH --gpus-per-task=1
#SBATCH --cpus-per-task=64
#SBATCH --ntasks=1
#SBATCH --mem=200G
#SBATCH --constraint=a100-80gb,ib
#SBATCH --time=1-00:00:00

# PATH to this directory
sourcedir=$PWD
errormsg="ERROR: "

# Check for input arguments
if [[ "$1" == "" ]] || [[ "$2" == "" ]]; then
    echo "${errormsg} Please enter a micrograph and template and filename."
    exit
fi

# Accept input arguments 
micrograph=$(readlink -e $1)
template=$(readlink -e $2)

# Check if they exist
if [[ "$micrograph" == "" ]]; then
    echo $errormsg
    echo "Input path $1 does not exist"
    exit
fi
if [[ "$template" == "" ]]; then
    echo $errormsg
    echo "Input path $2 does not exist"
    exit
fi

# cisTEM environment
source $sourcedir/../configure-env

# Read metadata into environment (for example, pixel size)
source $sourcedir/../configure-metadata

# Set variables for processing
micrograph_label=$(basename -- $(basename -- $micrograph) .mrc)
template_label=$(basename -- $(basename -- $template) .mrc)
ctf=$(readlink -e $sourcedir/../ctfs/${micrograph_label}_diagnostic_output.txt)
outputdir=$sourcedir/../output

if [ "$ctf" == "" ]; then
    echo $errormsg
    echo "CTF output $ctf does not exist."
    exit
fi

# Run template matching
defocus1=`tail -1 $ctf | awk '{print $2}' `
defocus2=`tail -1 $ctf | awk '{print $3}'`
astig_angle=`tail -1 $ctf | awk '{print $4}'`
echo $defocus1 $defocus2 $astig_angle

match_template << EOF
$micrograph
$template
$outputdir/${micrograph_label}_${template_label}_mip.mrc
$outputdir/${micrograph_label}_${template_label}_mip_scaled.mrc
$outputdir/${micrograph_label}_${template_label}_psi.mrc
$outputdir/${micrograph_label}_${template_label}_theta.mrc
$outputdir/${micrograph_label}_${template_label}_phi.mrc
$outputdir/${micrograph_label}_${template_label}_defocus.mrc
$outputdir/${micrograph_label}_${template_label}_pixel_size.mrc
$outputdir/${micrograph_label}_${template_label}_corr_average.mrc
$outputdir/${micrograph_label}_${template_label}_corr_variance.mrc
$outputdir/${micrograph_label}_${template_label}_histogram.txt
$pixelsize
$voltage
$spherical_aberration
$amplitude_contrast
$defocus1
$defocus2
$astig_angle
0.0
3.0
2.5
1.5
1000
0.0
0.1
0.0
1.0
0.1
C1
Yes
4
EOF
