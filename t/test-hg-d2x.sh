. ./lib.sh

create_darcs test --hashed

rm -rf test.hg
if [ "$1" != "--stdout" ]; then
	d2x -f hg test
	diff_hg test
	exit $?
else
	darcs-fast-export test
fi
