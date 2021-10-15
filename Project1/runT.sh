#!/bin/bash

i=0
sourceTXT=()

if [ $# -ne 0 ] 
then
	if [ $1 == "-h" ] 
	then
		echo "('leap' 'skip' 'mm2mmm' 'copy' 'd2dddd' 'd2dd' 'date2year' 'R2A')"
		exit 0
	else
		for arg; do
			sourceTXT[i]=$arg
			i=$((i+1))
		done
	fi
else 
	sourceTXT=("leap" "skip" "mm2mmm" "copy" "d2dddd" "d2dd" "date2year" "R2A")
fi

if [ $# -eq 0 ] 
then
	echo ">> Compiling (sources/):"
	for i in sources/*.txt; do
		printf "$(basename $i) | "
	    fstcompile --isymbols=syms.txt --osymbols=syms.txt $i | fstarcsort > compiled/$(basename $i ".txt").fst
	done
	printf "\n\n"

	echo ">> Compiling (tests/):"
	for i in tests/*.txt; do
		printf "$(basename $i) | "
	    fstcompile --isymbols=syms.txt --osymbols=syms.txt $i | fstarcsort > compiled/$(basename $i ".txt").fst
	done
	printf "\n\n"

	# TODO
	echo ">> Creating image (images/):"
	for i in compiled/*.fst; do
		printf "$(basename $i '.fst').pdf | "
	    fstdraw --portrait --isymbols=syms.txt --osymbols=syms.txt $i | dot -Tpdf > images/$(basename $i '.fst').pdf
	done
	printf "\n\n"
else
	echo ">> Compiling (sources/):"
	for ii in ${sourceTXT[*]}; do
		for i in sources/$ii.txt; do
			printf "$(basename $i) | "
			fstcompile --isymbols=syms.txt --osymbols=syms.txt $i | fstarcsort > compiled/$(basename $ii ".txt").fst
		done
	done
	printf "\n\n"

	echo ">> Compiling (tests/):"
	for ii in ${sourceTXT[*]}; do
		for i in tests/$ii[0-9]*.txt; do
			printf "$(basename $i) | "
		    fstcompile --isymbols=syms.txt --osymbols=syms.txt $i | fstarcsort > compiled/$(basename $ii ".txt").fst
		done
	done
	printf "\n\n"

	echo ">> Creating image (images/):"
	for ii in ${sourceTXT[*]}; do
		for i in compiled/$ii[0-9]*.fst; do
			printf "$(basename $i '.fst').pdf | "
		    fstdraw --portrait --isymbols=syms.txt --osymbols=syms.txt $i | dot -Tpdf > images/$(basename $ii '.fst').pdf
		done
	done
	printf "\n\n"
fi


for i in ${sourceTXT[*]}; do
	for ii in tests/$i[0-9]*.txt; do
		echo ">> Testing the transducer '$i' with the input 'tests/"$(basename $ii)"' (stdout)"
		fstcompose compiled/"$(basename $ii '.txt')".fst compiled/"$i".fst | fstshortestpath | fstproject --project_type=output | fstrmepsilon | fsttopsort | fstprint --acceptor --isymbols=./syms.txt
	done
done
