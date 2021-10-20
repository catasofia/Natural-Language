#!/bin/bash

# Group 12
# Catarina Sousa 93695 
# Nelson Trindade 93743

# Compile
echo ">> Compiling (sources/):"
for i in sources/*.txt; do
	printf "$(basename $i) | "
    fstcompile --isymbols=syms.txt --osymbols=syms.txt $i | fstarcsort > compiled/$(basename $i ".txt").fst
done
printf "\n\n"

# (2) Machines
echo ">> Building derived transducers (compiled/):"
printf "A2R.fst | "
fstinvert compiled/R2A.fst > compiled/A2R.fst

printf "birthR2A.fst | "
fstcompose compiled/R2A.fst compiled/d2dd.fst > compiled/composed.fst
fstconcat compiled/composed.fst compiled/copy.fst > compiled/concat.fst
fstconcat compiled/concat.fst compiled/composed.fst > compiled/concat_aux.fst
fstconcat compiled/concat_aux.fst compiled/copy.fst > compiled/concat1.fst
fstcompose compiled/R2A.fst compiled/d2dddd.fst > compiled/composed2.fst
fstconcat compiled/concat1.fst compiled/composed2.fst > compiled/birthR2A.fst
rm compiled/composed.fst compiled/concat.fst compiled/concat_aux.fst compiled/concat1.fst compiled/composed2.fst

printf "birthA2T.fst | "
fstconcat compiled/copy.fst compiled/copy.fst > compiled/copy2.fst
fstconcat compiled/copy2.fst compiled/copy.fst > compiled/copy3.fst
fstconcat compiled/copy3.fst compiled/mm2mmm.fst > compiled/month.fst
fstconcat compiled/month.fst compiled/copy.fst > compiled/month1.fst
fstconcat compiled/month1.fst compiled/copy.fst > compiled/month2.fst
fstconcat compiled/month2.fst compiled/copy.fst > compiled/month3.fst
fstconcat compiled/month3.fst compiled/copy.fst > compiled/month4.fst
fstconcat compiled/month4.fst compiled/copy.fst > compiled/birthA2T.fst
rm compiled/copy2.fst compiled/copy3.fst compiled/month.fst compiled/month1.fst compiled/month2.fst compiled/month3.fst compiled/month4.fst

printf "birthT2R.fst | "
fstinvert compiled/birthR2A.fst > compiled/invertedBirthR2A.fst
fstinvert compiled/birthA2T.fst > compiled/invertedBirthA2T.fst
fstcompose compiled/invertedBirthA2T.fst compiled/invertedBirthR2A.fst > compiled/birthT2R.fst
rm compiled/invertedBirthR2A.fst compiled/invertedBirthA2T.fst

printf "birthR2L.fst |"
fstcompose compiled/birthR2A.fst compiled/date2year.fst > compiled/birthR2L_aux.fst
fstcompose compiled/birthR2L_aux.fst compiled/leap.fst > compiled/birthR2L.fst
rm compiled/birthR2L_aux.fst 


# Compiling Tests
printf "\n\n"
echo ">> Compiling (tests/):"
for i in tests/*.txt; do
	printf "$(basename $i) | "
    fstcompile --isymbols=syms.txt --osymbols=syms.txt $i | fstarcsort > compiled/$(basename $i ".txt").fst
done
printf "\n\n"

# PDF's
echo ">> Creating image (images/):"
for i in compiled/*.fst; do
	printf "$(basename $i '.fst').pdf | "
    fstdraw --portrait --isymbols=syms.txt --osymbols=syms.txt $i | dot -Tpdf > images/$(basename $i '.fst').pdf
done
printf "\n\n"


# Tests
echo "Testing the transducer 'birthR2A' with the input 'tests/93695birthR2A.txt' (stdout)"
fstcompose compiled/93695birthR2A.fst compiled/birthR2A.fst | fstshortestpath | fstproject --project_type=output | fstrmepsilon | fsttopsort | fstprint --acceptor --isymbols=./syms.txt

echo "Testing the transducer 'birthR2A' with the input 'tests/93743birthR2A.txt' (stdout)"
fstcompose compiled/93743birthR2A.fst compiled/birthR2A.fst | fstshortestpath | fstproject --project_type=output | fstrmepsilon | fsttopsort | fstprint --acceptor --isymbols=./syms.txt

echo "Testing the transducer 'birthA2T' with the input 'tests/93695birthA2T.txt' (stdout)"
fstcompose compiled/93695birthA2T.fst compiled/birthA2T.fst | fstshortestpath | fstproject --project_type=output | fstrmepsilon | fsttopsort | fstprint --acceptor --isymbols=./syms.txt

echo "Testing the transducer 'birthA2T' with the input 'tests/93743birthA2T.txt' (stdout)"
fstcompose compiled/93743birthA2T.fst compiled/birthA2T.fst | fstshortestpath | fstproject --project_type=output | fstrmepsilon | fsttopsort | fstprint --acceptor --isymbols=./syms.txt

echo "Testing the transducer 'birthR2L' with the input 'tests/93695birthR2L.txt' (stdout)"
fstcompose compiled/93695birthR2L.fst compiled/birthR2L.fst | fstshortestpath | fstproject --project_type=output | fstrmepsilon | fsttopsort | fstprint --acceptor --isymbols=./syms.txt

echo "Testing the transducer 'birthR2L' with the input 'tests/93743birthR2L.txt' (stdout)"
fstcompose compiled/93743birthR2L.fst compiled/birthR2L.fst | fstshortestpath | fstproject --project_type=output | fstrmepsilon | fsttopsort | fstprint --acceptor --isymbols=./syms.txt

echo "Testing the transducer 'birthT2R' with the input 'tests/93695birthT2R.txt' (stdout)"
fstcompose compiled/93695birthT2R.fst compiled/birthT2R.fst | fstshortestpath | fstproject --project_type=output | fstrmepsilon | fsttopsort | fstprint --acceptor --isymbols=./syms.txt

echo "Testing the transducer 'birthT2R' with the input 'tests/93743birthT2R.txt' (stdout)"
fstcompose compiled/93743birthT2R.fst compiled/birthT2R.fst | fstshortestpath | fstproject --project_type=output | fstrmepsilon | fsttopsort | fstprint --acceptor --isymbols=./syms.txt
