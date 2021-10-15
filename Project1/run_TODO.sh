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
fstcompose compiled/R2A3999.fst compiled/R2A.fst | fstshortestpath | fstproject --project_type=output | fstrmepsilon | fsttopsort | fstprint --acceptor --isymbols=./syms.txt

echo "Inverting R2A"
fstinvert compiled/R2A.fst > compiled/A2R.fst

echo "Testing the transducer 'A2R' with the input 'tests/A2R2000' (stdout)"
fstcompose compiled/A2R2000.fst compiled/A2R.fst | fstshortestpath | fstproject --project_type=output | fstrmepsilon | fsttopsort | fstprint --acceptor --isymbols=./syms.txt

echo "building birthR2A"
fstcompose compiled/R2A.fst compiled/d2dd.fst > compiled/composed.fst
fstconcat compiled/composed.fst compiled/copy.fst > compiled/concat.fst
fstconcat compiled/concat.fst compiled/composed.fst > compiled/concat_aux.fst
fstconcat compiled/concat_aux.fst compiled/copy.fst > compiled/concat1.fst
fstcompose compiled/R2A.fst compiled/d2dddd.fst > compiled/composed2.fst
fstconcat compiled/concat1.fst compiled/composed2.fst > compiled/birthR2A.fst


echo "Testing the transducer 'birthR2A' with the input 'tests/' (stdout)"
fstcompose compiled/testarUniao.fst compiled/birthR2A.fst | fstshortestpath | fstproject --project_type=output | fstrmepsilon | fsttopsort | fstprint --acceptor --isymbols=./syms.txt

rm compiled/composed.fst compiled/concat.fst compiled/concat_aux.fst compiled/concat1.fst compiled/composed2.fst


echo "Building birthA2T"
fstconcat compiled/copy.fst compiled/copy.fst > compiled/copy2.fst
fstconcat compiled/copy2.fst compiled/copy.fst > compiled/copy3.fst
fstconcat compiled/copy3.fst compiled/mm2mmm.fst > compiled/month.fst
fstconcat compiled/month.fst compiled/copy.fst > compiled/month1.fst
fstconcat compiled/month1.fst compiled/copy.fst > compiled/month2.fst
fstconcat compiled/month2.fst compiled/copy.fst > compiled/month3.fst
fstconcat compiled/month3.fst compiled/copy.fst > compiled/month4.fst
fstconcat compiled/month4.fst compiled/copy.fst > compiled/birthA2T.fst

rm compiled/copy2.fst compiled/copy3.fst compiled/month.fst compiled/month1.fst compiled/month2.fst compiled/month3.fst compiled/month4.fst

echo "Testing the transducer 'birthA2T' with the input 'tests/' (stdout)"
fstcompose compiled/birthA2T_test.fst compiled/birthA2T.fst | fstshortestpath | fstproject --project_type=output | fstrmepsilon | fsttopsort | fstprint --acceptor --isymbols=./syms.txt

echo "Building birthT2R"
fstinvert compiled/birthR2A.fst > compiled/invertedBirthR2A.fst
fstinvert compiled/birthA2T.fst > compiled/invertedBirthA2T.fst
fstcompose compiled/invertedBirthA2T.fst compiled/invertedBirthR2A.fst > compiled/birthT2R.fst

rm compiled/invertedBirthR2A.fst compiled/invertedBirthA2T.fst

echo "Testing the transducer 'birthT2R' with the input 'tests/' (stdout)"
fstcompose compiled/birthT2R_test.fst compiled/birthT2R.fst | fstshortestpath | fstproject --project_type=output | fstrmepsilon | fsttopsort | fstprint --acceptor --isymbols=./syms.txt

echo "Building birthR2L"
fstcompose compiled/birthR2A.fst compiled/date2year.fst > compiled/birthR2L_aux.fst
fstcompose compiled/birthR2L_aux.fst compiled/leap.fst > compiled/birthR2L.fst

rm compiled/birthR2L_aux.fst 

echo "Testing the transducer 'birthR2L' with the input 'tests/' (stdout)"
fstcompose compiled/birthR2L_test.fst compiled/birthR2L.fst | fstshortestpath | fstproject --project_type=output | fstrmepsilon | fsttopsort | fstprint --acceptor --isymbols=./syms.txt

