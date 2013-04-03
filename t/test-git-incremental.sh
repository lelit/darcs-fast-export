. ./lib.sh

create_darcs test --hashed

rm -rf test.darcs test.git
mkdir test.git
cd test.git
git --bare init
cd ..
if [ "$1" != "--stdout" ]; then
	dmark="$(pwd)/test.dfe-marks"
	gmark="$(pwd)/test.gfi-marks"
	rm -f $mark $gmark
	darcs-fast-export --export-marks=$dmark test |(cd test.git; git fast-import --export-marks=$gmark)
	diff_git test || die "initial conversion differs"
	upd_file_darcs test file2 upd_contents
	darcs-fast-export --export-marks=$dmark --import-marks=$dmark test |(cd test.git; git fast-import --export-marks=$gmark --import-marks=$gmark)
	diff_git test || die "update differs"
	upd_file_darcs test hungarian.gif "binary to text"
	darcs-fast-export --export-marks=$dmark --import-marks=$dmark test |(cd test.git; git fast-import --export-marks=$gmark --import-marks=$gmark)
	diff_git test || die "update2 differs"
	# assert that deleting a file in darcs, then doing an incremental
	# darcs-to-git, correctly deletes the file in git too
	rm_file_darcs test file2
	darcs-fast-export --export-marks=$dmark --import-marks=$dmark test |(cd test.git; git fast-import --export-marks=$gmark --import-marks=$gmark)
	diff_git test || die "rm file2 differs"
else
	darcs-fast-export test
fi
