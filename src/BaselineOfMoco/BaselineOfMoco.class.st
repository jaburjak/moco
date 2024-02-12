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
					package: 'Moco-Uml' with: [ spec requires: #('Moco-Core') ];
					package: 'Moco-OntoUml' with: [ spec requires: #('Moco-Core' 'Moco-Uml') ];
					package: 'Moco-O2U' with: [ spec requires: #('Moco-Core' 'Moco-OntoUml' 'Moco-Uml') ];
					package: 'Moco-RdbOracle' with: [ spec requires: #('Moco-Core') ];
					package: 'Moco-U2D' with: [ spec requires: #('Moco-Core' 'Moco-Uml' 'Moco-RdbOracle') ];
					package: 'Moco-SqlOracle' with: [ spec requires: #('Moco-Core') ];
					package: 'Moco-D2S' with: [ spec requires: #('Moco-Core' 'Moco-RdbOracle' 'Moco-SqlOracle') ];
					package: 'Moco-OpenPonk' with: [ spec requires: #('Moco-Core' 'Moco-OntoUml' 'Moco-O2U' 'Moco-U2D' 'Moco-D2S') ] ]
]

{ #category : #accessing }
BaselineOfMoco >> projectClass [
	^ MetacelloCypressBaselineProject
]
