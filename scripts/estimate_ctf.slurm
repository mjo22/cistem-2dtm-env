#!/usr/bin/env bash
#
# Estimate the CTF of a single micrograph
#
# The stdout (-o) and stderr (-e) files
#SBATCH -o outrunLog.%j.%A.%a.%N.out
#SBATCH -e errrunLog.%j.%A.%a.%N.err
# slurm settings
#SBATCH -p ccb
#SBATCH --nodes=1
#SBATCH --exclusive
#SBATCH --constraint=icelake
#SBATCH --time=0-01:00:00

# Path to this directory
sourcedir=$PWD
errormsg="ERROR: "

# Check for input arguments
if [[ "$1" == "" ]]; then
    echo "${errormsg} Please enter an existing micrograph."
    exit
fi

# Accept input arguments
micrograph=$(readlink -e $1)
label=$(basename -- $(basename -- $micrograph) .mrc)

# Check if they exist
if [[ "$micrograph" == "" ]]; then
    echo $errormsg
    echo "Input path $1 does not exist."
    exit
fi

# cisTEM environment
source $sourcedir/../configure-env

# Read metadata into environment
source $sourcedir/../configure-metadata

# Set variables for processing
label=$(basename -- $(basename -- $micrograph) .mrc)
ctfdir=$(readlink -e $sourcedir/../ctfs)

if [ "$ctfdir" == "" ]; then
    echo $errormsg
    echo "Output directory $ctfdir does not exist."
fi

# Estimate CTF
ctffind << EOF
$micrograph
$ctfdir/${label}_diagnostic_output.mrc
$pixelsize
$voltage
$spherical_aberration
$amplitude_contrast
512
30
3
5000
50000
100
No
No
No
No
No
No
EOF
