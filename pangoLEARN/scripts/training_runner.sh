#!/bin/bash

#source /localdisk/home/s1680070/.bashrc
#conda activate pangolin

TODAY=$(date +%F)
OUT=${TODAY}_pangoLEARN
OUTDIR=/localdisk/home/shared/raccoon-dog/$OUT

echo $OUTDIR

if [ -d $OUTDIR ] 
then
    echo "Directory $OUTDIR exists." 
els
    mkdir $OUTDIR 
    echo "Directory $OUTDIR does not exist, making it."
fi

echo "Training model version: $TODAY"

if [ -z "$1" ]
then
    UID="s1680070"
else
    UID=$1
fi

if [ -z "$2" ]
then
    DATA_DATE=$TODAY
else
    DATA_DATE=$2
fi
echo "$UID training version $DATA_DATE"

# LATEST_DATA=$(ls -td /localdisk/home/shared/raccoon-dog/2021*_gisaid/publish/gisaid | head -n 1)

REPO_PATH=/localdisk/home/s1680070/repositories

PANGO_PATH=$REPO_PATH/pango-designation
PLEARN_PATH=$REPO_PATH/pangoLEARN

echo "pango designation path $PANGO_PATH"
echo "pangoLEARN path $PLEARN_PATH"

cd $PANGO_PATH && git pull #gets any updates to the reports in the data directory
PANGO_VERSION=$(git describe --tags --abbrev=0)

cd /localdisk/home/shared/raccoon-dog/ #gets any updates to the reports in the data directory
echo "--config outdir=$OUTDIR data_date=$DATA_DATE pangolearn_version=$TODAY "
echo "pangoLEARN training starting" | mail -s "update lineageTree.pb with pango designation version $PANGO_VERSION" angie@soe.ucsc.edu
snakemake --snakefile $PLEARN_PATH/pangoLEARN/scripts/curate_alignment.smk --rerun-incomplete --nolock --cores 1 --config repo_path=$REPO_PATH outdir=$OUTDIR data_date=$DATA_DATE pangolearn_version=$TODAY pango_version=$PANGO_VERSION
