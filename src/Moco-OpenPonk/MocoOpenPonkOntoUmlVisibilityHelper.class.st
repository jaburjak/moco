Class {
	#name : #MocoOpenPonkOntoUmlVisibilityHelper,
	#superclass : #Object,
	#category : #'Moco-OpenPonk-Utils'
}

{ #category : #'as yet unclassified' }
MocoOpenPonkOntoUmlVisibilityHelper class >> toMocoVisibility: aVisibility [
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
