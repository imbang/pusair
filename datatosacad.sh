#/bin/bash

# created by Bayu Imbang L,27 Feb 2013 @KNMI
# =========================================
# obj : convert *.txt.data to data.XXX.rr.txt 

tmp=tmp.out.$$
regfile=reg.out.$$

if [ -e $tmp ];then rm $tmp;fi
if [ -e $regfile ];then rm $regfile;fi

start=$1
endstart=$2

for i in `seq $1 1 $2`
do
  printf "region%02d.txt.data\n" $i >> $regfile
done

for fl in *.txt.data
do
  res=`cat $regfile | grep $fl | wc -l`
  if [ $res -eq 0 ];then echo "++++ $fl tidak ketemu....";continue;fi
  
  awk '{print $1'} $fl | uniq -c | awk '{print $2}' > $tmp
  cat $tmp | while read LINE
  do
    echo "Writing to data.$LINE.rr.txt ...."
    awk -v VAR=$LINE '$1==VAR {print}' $fl > data.$LINE.rr.txt
  done
  #res=`cat $regfile | grep $fl | wc -l`
  #if [ $res -eq 0 ];then continue;fi
  #outfil=`echo $fl | sed "s/.txt.data//g"`
  #echo "Writing to sacad.$outfil ...."
  #awk '{print $1,$2,$3,-9,-9,-9}' $fl > sacad.$outfil
  #awk -v q="'" '{print $1,q$2q,$3,-9,-9,-9}' $fl > sacad.$outfil
done
#head -1 data.01992X.rr.txt | awk '{print $2}'