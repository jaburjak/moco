Class {
	#name : #MocoOpenPonkOntoUmlShareabilityHelper,
	#superclass : #Object,
	#category : #'Moco-OpenPonk-Utils'
}

{ #category : #transforming }
MocoOpenPonkOntoUmlShareabilityHelper class >> toMocoShareability: aSymbol [
	aSymbol
		ifNil: [ ^ MocoOntoUmlAssociationShareability new. ]
		ifNotNil: [
			(aSymbol = #composite)
				ifTrue: [ ^ MocoOntoUmlAssociationShareability exclusive. ]
				ifFalse: [
					(aSymbol = #shared) ifTrue: [ ^ MocoOntoUmlAssociationShareability shared. ] ifFalse: [ ^ MocoOntoUmlAssociationShareability new. ]
				]
		]
]
