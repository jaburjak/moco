#!/bin/bash

set -e

SUITES=("MocoOpenPonkTestSuite" "MocoO2UTestSuite" "MocoU2DTestSuite" "MocoD2SOracleTestSuite")

for suite in "${SUITES[@]}"; do
	echo "$suite:"
	./pharo/bin/pharo --headless image/openponk-class-editor.image eval "| r | r := $suite new run. r hasPassed ifFalse: [ Transcript show: r; cr. ^ SmalltalkImage current exitFailure ]. ^ r"
done