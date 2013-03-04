#/bin/bash

#/bin/bash

# created by Bayu Imbang L,27 Feb 2013 @KNMI
# =========================================
# obj : convert raw comma-delimited to *.txt.data

tmp=tmp.out.$$
regfile=reg.out.$$

if [ -e $tmp ];then rm $tmp;fi
if [ -e $regfile ];then rm $regfile;fi

start=$1
endstart=$2

for i in `seq $1 1 $2`
do
  printf "region%02d.txt\n" $i >> $regfile
done

#exit

ofset=3

for fl in *.txt
do
  res=`cat $regfile | grep $fl | wc -l`
  if [ $res -eq 0 ];then continue;fi
  outfil=$fl.data
  #echo -n "Apakah akan melakukan konversi $fl ? (y/n)"
  #read hasil
  #if [ $hasil == "N" ] || [ $hasil == "n" ];then
	#continue
  #fi
  echo "Writing to $outfil ...."
  awk "NR>1 {print}" $fl > $tmp
  cat $tmp | while read LINE
  do
    nosta=`echo $LINE | awk -F, '{print $1}'`
    nosta=`echo $nosta | sed "s/\"//g"`
    if [ $nosta == "-" ];then continue;fi
    tahun=`echo $LINE | awk -F, '{print $2}'`
    tahun=`echo $tahun | bc`
    bulan=`echo $LINE | awk -F, '{print $3}'`
    bulan=`echo $bulan | bc`
    enday=`cal 1 $bulan $tahun | grep . | fmt -1 | tail -1`
    echo "$nosta $tahun $bulan"
    for hr in `seq 1 1 $enday`;do
      #let idx=$hr+$ofset
      idx=`echo "$hr*2-1" | bc`
      let idx=$idx+$ofset
      value=`echo $LINE | awk -F, -v VAR=$idx '{print $VAR}'`
      if [ $value == "" ];then value=-9999;fi
      if [[ $bulan>=1  && $bulan<=12 ]];then
      #if [ $bulan>=1 ];then
	echo "$nosta $tahun-$bulan-$hr $value" >> $outfil
      fi
    done
  done
done