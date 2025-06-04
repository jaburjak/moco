"
BaselineOfMoco
"
Class {
	#name : #BaselineOfMoco,
	#superclass : #BaselineOf,
	#category : #BaselineOfMoco
}

{ #category : #baselines }
BaselineOfMoco >> baseline: spec [
	<baseline>
	spec
		for: #common
			do: [
				"Packages"
				spec
					package: 'Moco-Core';
					package: 'Moco-Core-Tests' with: [ spec requires: #('Moco-Core') ];
					package: 'Moco-Uml' with: [ spec requires: #('Moco-Core') ];
					package: 'Moco-OntoUml' with: [ spec requires: #('Moco-Core' 'Moco-Uml') ];
					package: 'Moco-Ocl' with: [ spec requires: #('Moco-Core') ];
					package: 'Moco-O2U' with: [ spec requires: #('Moco-Core' 'Moco-OntoUml' 'Moco-Uml' 'Moco-Ocl') ];
					package: 'Moco-O2U-Tests' with: [ spec requires: #('Moco-Core-Tests' 'Moco-O2U') ];
					package: 'Moco-Rdb' with: [ spec requires: #('Moco-Core') ];
					package: 'Moco-U2D' with: [ spec requires: #('Moco-Core' 'Moco-Uml' 'Moco-Ocl' 'Moco-Rdb') ];
					package: 'Moco-U2D-Tests' with: [ spec requires: #('Moco-Core-Tests' 'Moco-U2D') ];
					package: 'Moco-SqlOracle' with: [ spec requires: #('Moco-Core' 'Moco-Rdb') ];
					package: 'Moco-D2S' with: [ spec requires: #('Moco-Core' 'Moco-Rdb' 'Moco-SqlOracle') ];
					package: 'Moco-D2S-Tests' with: [ spec requires: #('Moco-Core-Tests' 'Moco-D2S') ];
					package: 'Moco-SqlPostgresql' with: [ spec requires: #('Moco-Core' 'Moco-Rdb') ];
					package: 'Moco-D2SPostgresql' with: [ spec requires: #('Moco-Core' 'Moco-Rdb' 'Moco-SqlPostgresql') ];
					package: 'Moco-SqlMysql' with: [ spec requires: #('Moco-Core' 'Moco-Rdb') ];
					package: 'Moco-OpenPonk' with: [ spec requires: #('Moco-Core' 'Moco-OntoUml' 'Moco-O2U' 'Moco-U2D' 'Moco-D2S') ] ];
					package: 'Moco-OpenPonk-Tests' with: [ spec requires: #('Moco-Core-Tests' 'Moco-OpenPonk') ]
]

{ #category : #accessing }
BaselineOfMoco >> projectClass [
	^ MetacelloCypressBaselineProject
]
