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
		attr visibility visibility: ((MocoOpenPonkOntoUmlVisibilityHelper toMocoVisibility: (each visibility)) visibility).
		attr static: each isStatic.
		attr immutable: each isReadOnly.
		attr multiplicity lower: (MocoUmlMultiplicityBound value: ((each lowerValue) ifNil: [ 1 ] ifNotNil: [ each lowerValue value ])).
		attr multiplicity upper: (MocoUmlMultiplicityBound value: ((each upperValue) ifNil: [ 1 ] ifNotNil: [ each upperValue value ])).
		each type ifNotNil: [ attr type: (MocoOntoUmlType newFromName: (each type name)) ].
		
		attr.
	].
]

{ #category : #transforming }
MocoOpenPonkOntoUmlAttributeHelper class >> toOpenPonkMultiplicity: aMocoUmlMultiplicity [
	| lower upper |
	
	(aMocoUmlMultiplicity lower isUnbounded)
		ifTrue: [ lower := OPUMLLiteralInteger new value: '*' ]
		ifFalse: [ lower := OPUMLLiteralInteger new value: (aMocoUmlMultiplicity lower value) ].
	
	(aMocoUmlMultiplicity upper isUnbounded)
		ifTrue: [ upper := OPUMLLiteralUnlimitedNatural new value: '*' ]
		ifFalse: [ upper := OPUMLLiteralUnlimitedNatural new value: (aMocoUmlMultiplicity upper value) ].
		
	^ { lower. upper }
]
