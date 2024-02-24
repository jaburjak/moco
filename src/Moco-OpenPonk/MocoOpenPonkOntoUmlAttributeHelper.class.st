Class {
	#name : #MocoOpenPonkOntoUmlAttributeHelper,
	#superclass : #Object,
	#category : #'Moco-OpenPonk-Utils'
}

{ #category : #'as yet unclassified' }
MocoOpenPonkOntoUmlAttributeHelper class >> getMocoAttributesFrom: anOpenPonkSortal [
	^ anOpenPonkSortal ownedAttributes collect: [ :each |
		| attr |
		attr := MocoOntoUmlAttribute new.
		
		attr name: each name.
		each visibility ifNil: [ attr visibility: MocoUmlVisibility public. ] ifNotNil: [ attr visibility visibility: each visibility asSymbol ].
		attr static: each isStatic.
		attr multiplicity lower: (MocoUmlMultiplicityBound value: (each lowerValue value)).
		attr multiplicity upper: (MocoUmlMultiplicityBound value: (each upperValue value)).
		each type ifNotNil: [ attr type: each type name ].
		
		attr.
	].
]
