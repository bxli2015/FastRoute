#!/usr/bin/env bash

################################################################################
## Authors: Mateus Fogaca, Eder Matheus Monteiro
##          (Advisor: Ricardo Reis)
##
## BSD 3-Clause License
##
## Copyright (c) 2019, Federal University of Rio Grande do Sul (UFRGS)
## All rights reserved.
##
## Redistribution and use in source and binary forms, with or without
## modification, are permitted provided that the following conditions are met:
##
## * Redistributions of source code must retain the above copyright notice, this
##   list of conditions and the following disclaimer.
##
## * Redistributions in binary form must reproduce the above copyright notice,
##   this list of conditions and the following disclaimer in the documentation
##   and#or other materials provided with the distribution.
##
## * Neither the name of the copyright holder nor the names of its
##   contributors may be used to endorse or promote products derived from
##   this software without specific prior written permission.
##
## THIS SOFTWARE IS PROVIDED BY THE COPYRIGHT HOLDERS AND CONTRIBUTORS "AS IS"
## AND ANY EXPRESS OR IMPLIED WARRANTIES, INCLUDING, BUT NOT LIMITED TO, THE
## IMPLIED WARRANTIES OF MERCHANTABILITY AND FITNESS FOR A PARTICULAR PURPOSE
## ARE DISCLAIMED. IN NO EVENT SHALL THE COPYRIGHT HOLDER OR CONTRIBUTORS BE
## LIABLE FOR ANY DIRECT, INDIRECT, INCIDENTAL, SPECIAL, EXEMPLARY, OR
## CONSEQUENTIAL DAMAGES (INCLUDING, BUT NOT LIMITED TO, PROCUREMENT OF
## SUBSTITUTE GOODS OR SERVICES; LOSS OF USE, DATA, OR PROFITS; OR BUSINESS
## INTERRUPTION) HOWEVER CAUSED AND ON ANY THEORY OF LIABILITY, WHETHER IN
## CONTRACT, STRICT LIABILITY, OR TORT (INCLUDING NEGLIGENCE OR OTHERWISE)
## ARISING IN ANY WAY OUT OF THE USE OF THIS SOFTWARE, EVEN IF ADVISED OF THE
## POSSIBILITY OF SUCH DAMAGE.
################################################################################

GREEN=0
RED=2

if [ "$#" -ne 2 ]; then
	exit 2
fi

binary=$1
testdir=$2

lefFile="$testdir/input/input.lef"
defFile="$testdir/input/input.def"

cp $testdir/src/test_guides/routeDesign.tcl $testdir/src/test_guides/run.tcl
sed -i s#_LEF_#$lefFile#g $testdir/src/test_guides/run.tcl
sed -i s#_DEF_#$defFile#g $testdir/src/test_guides/run.tcl

ln -sf $testdir/../../../etc/POWV9.dat POWV9.dat
ln -sf $testdir/../../../etc/POST9.dat POST9.dat

$binary < run.tcl > log.txt 2>&1

diff golden.guide out.guide
status=$?

if [ $status -eq 0 ]
then
	exit $GREEN
else
        echo "     - [ERROR] Test failed. Check $testdir/src/test_guides/test.log and Check $testdir/src/test_guides/golden.guide"
	exit $RED
fi