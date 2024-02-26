"
Transforms OpenPonk’s OntoUML generalizations into their Moco counterparts.
"
Class {
	#name : #MocoOpenPonkOntoUmlGeneralizationTransformationRule,
	#superclass : #MocoTransformationRule,
	#category : #'Moco-OpenPonk-Rule'
}

{ #category : #accessing }
MocoOpenPonkOntoUmlGeneralizationTransformationRule >> executeOn: anEngine [
	| elements helper |
	elements := anEngine inModel elements select: [ :e | (e innerElement class canUnderstand: #generalizations) and: [ e innerElement generalizations isEmpty not ] ].
	elements := elements select: [ :e | e meta outElements noneSatisfy: [ :o | o innerElement isKindOf: MocoOntoUmlGeneralization ] ].
	
	helper := MocoOpenPonkOntoUmlGeneralizationHelper withEngine: anEngine.
	
	elements do: [ :each |
		| generalizations |
		generalizations := helper getMocoGeneralizationsFrom: (each innerElement).
		generalizations := generalizations collect: [ :g | MocoWrappedElement from: g ].
		
		anEngine outModel elements addAll: generalizations.
		each meta outElements addAll: generalizations.
		
		generalizations isEmpty ifFalse: [ anEngine outModel meta didChange: true ].
	].
]

{ #category : #accessing }
MocoOpenPonkOntoUmlGeneralizationTransformationRule >> priority [
	^ 60
]
