#!/bin/bash

SUITES=("MocoOpenPonkTestSuite" "MocoO2UTestSuite" "MocoU2DTestSuite")

for suite in "${SUITES[@]}"; do
	./pharo/bin/pharo --headless image/openponk-class-editor.image eval "| r | r := $suite new run. (r tests size) = (r passed size)" | grep true
done