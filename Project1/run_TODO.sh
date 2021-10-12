#!/bin/bash

for i in sources/*.txt tests/*.txt; do
	echo "Compiling: $i"
    fstcompile --isymbols=syms.txt --osymbols=syms.txt $i | fstarcsort > compiled/$(basename $i ".txt").fst
done


# TODO

for i in compiled/*.fst; do
	echo "Creating image: images/$(basename $i '.fst').pdf"
    fstdraw --portrait --isymbols=syms.txt --osymbols=syms.txt $i | dot -Tpdf > images/$(basename $i '.fst').pdf
done

echo "Testing the transducer 'mm2mmm' with the input 'tests/mm2mmm10.txt' (stdout)"
fstcompose compiled/mm2mmm10.fst compiled/mm2mmm.fst | fstshortestpath | fstproject --project_type=output | fstrmepsilon | fsttopsort | fstprint --acceptor --isymbols=./syms.txt

echo "Testing the transducer 'mm2mmm' with the input 'tests/mm2mmm05.txt' (stdout)"
fstcompose compiled/mm2mmm05.fst compiled/mm2mmm.fst | fstshortestpath | fstproject --project_type=output | fstrmepsilon | fsttopsort | fstprint --acceptor --isymbols=./syms.txt


echo "Testing the transducer 'copy' with the input 'tests/copy7.txt' (stdout)"
fstcompose compiled/copy7.fst compiled/copy.fst | fstshortestpath | fstproject --project_type=output | fstrmepsilon | fsttopsort | fstprint --acceptor --isymbols=./syms.txt

echo "Testing the transducer 'copy' with the input 'tests/copyslash.txt' (stdout)"
fstcompose compiled/copyslash.fst compiled/copy.fst | fstshortestpath | fstproject --project_type=output | fstrmepsilon | fsttopsort | fstprint --acceptor --isymbols=./syms.txt

echo "Testing the transducer 'copy' with the input 'tests/copy17.txt' (stdout)"
fstcompose compiled/copy17.fst compiled/copy.fst | fstshortestpath | fstproject --project_type=output | fstrmepsilon | fsttopsort | fstprint --acceptor --isymbols=./syms.txt

echo "Testing the transducer 'd2dd' with the input 'tests/d2dd5.txt' (stdout)"
fstcompose compiled/d2dd5.fst compiled/d2dd.fst | fstshortestpath | fstproject --project_type=output | fstrmepsilon | fsttopsort | fstprint --acceptor --isymbols=./syms.txt

echo "Testing the transducer 'd2dd' with the input 'tests/d2dd15.txt' (stdout)"
fstcompose compiled/d2dd15.fst compiled/d2dd.fst | fstshortestpath | fstproject --project_type=output | fstrmepsilon | fsttopsort | fstprint --acceptor --isymbols=./syms.txt

echo "Testing the transducer 'd2dd' with the input 'tests/d2dd2500.txt' (stdout)"
fstcompose compiled/d2dd2500.fst compiled/d2dd.fst | fstshortestpath | fstproject --project_type=output | fstrmepsilon | fsttopsort | fstprint --acceptor --isymbols=./syms.txt

echo "Testing the transducer 'd2dd' with the input 'tests/d2dd1.txt' (stdout)"
fstcompose compiled/d2dd1.fst compiled/d2dd.fst | fstshortestpath | fstproject --project_type=output | fstrmepsilon | fsttopsort | fstprint --acceptor --isymbols=./syms.txt

echo "Testing the transducer 'date2year' with the input 'tests/date2year10_02_2000.txt' (stdout)"
fstcompose compiled/date2year10_02_2000.fst compiled/date2year.fst | fstshortestpath | fstproject --project_type=output | fstrmepsilon | fsttopsort | fstprint --acceptor --isymbols=./syms.txt

echo "Testing the transducer 'date2year' with the input 'tests/date2year30_11_1987.txt' (stdout)"
fstcompose compiled/date2year30_11_1987.fst compiled/date2year.fst | fstshortestpath | fstproject --project_type=output | fstrmepsilon | fsttopsort | fstprint --acceptor --isymbols=./syms.txt

echo "Testing the transducer 'R2A' with the input 'tests/R2A_I' (stdout)"
fstcompose compiled/R2A_I.fst compiled/R2A.fst | fstshortestpath | fstproject --project_type=output | fstrmepsilon | fsttopsort | fstprint --acceptor --isymbols=./syms.txt
