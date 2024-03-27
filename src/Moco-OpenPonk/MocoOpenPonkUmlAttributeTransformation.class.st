"
Contains transformation between Moco UML and OpenPonk UML related to class attributes.
"
Class {
	#name : #MocoOpenPonkUmlAttributeTransformation,
	#superclass : #Object,
	#category : #'Moco-OpenPonk-Transformation'
}

{ #category : #transforming }
MocoOpenPonkUmlAttributeTransformation class >> toMocoVisibility: aVisibility [
	"Transforms an OpenPonk element visibility information to Moco type."
	
	aVisibility
		ifNil: [
			^ MocoUmlVisibility public
		]
		ifNotNil: [
			| visibility |
			visibility := MocoUmlVisibility new.
			visibility visibility: (aVisibility asSymbol).
			
			^ visibility
		].
]

{ #category : #transforming }
MocoOpenPonkUmlAttributeTransformation class >> toOpenPonkMultiplicity: aMocoUmlMultiplicity [
	"Transforms a Moco attribute multiplicity to an array with OpenPonk lower and upper bounds."
	
	| lower upper |
	
	(aMocoUmlMultiplicity lower isUnbounded)
		ifTrue: [ lower := OPUMLLiteralInteger new value: '*' ]
		ifFalse: [ lower := OPUMLLiteralInteger new value: (aMocoUmlMultiplicity lower value) ].
	
	(aMocoUmlMultiplicity upper isUnbounded)
		ifTrue: [ upper := OPUMLLiteralUnlimitedNatural new value: '*' ]
		ifFalse: [ upper := OPUMLLiteralUnlimitedNatural new value: (aMocoUmlMultiplicity upper value) ].
		
	^ { lower. upper }
]
