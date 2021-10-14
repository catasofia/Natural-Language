#!/bin/bash

echo ">> Compiling (sources/):"
for i in sources/*.txt; do
	printf "$i | "
    fstcompile --isymbols=syms.txt --osymbols=syms.txt $i | fstarcsort > compiled/$(basename $i ".txt").fst
done
printf "\n\n"

echo ">> Compiling (tests/):"
for i in tests/*.txt; do
	printf "$i | "
    fstcompile --isymbols=syms.txt --osymbols=syms.txt $i | fstarcsort > compiled/$(basename $i ".txt").fst
done
printf "\n\n"

# TODO
echo ">> Creating image (images/):"
for i in compiled/*.fst; do
	printf "$(basename $i '.fst').pdf |"
    fstdraw --portrait --isymbols=syms.txt --osymbols=syms.txt $i | dot -Tpdf > images/$(basename $i '.fst').pdf
done
printf "\n\n"

sourceTXT=("mm2mmm" "copy" "d2dddd" "d2dd" "date2year" "R2A")

for i in ${sourceTXT[*]}; do
	for ii in tests/$i[0-9]*.txt; do
		echo ">> Testing the transducer '$i' with the input 'tests/"$(basename $ii)"' (stdout)"
		fstcompose compiled/"$(basename $ii '.txt')".fst compiled/"$i".fst | fstshortestpath | fstproject --project_type=output | fstrmepsilon | fsttopsort | fstprint --acceptor --isymbols=./syms.txt
	done
done
