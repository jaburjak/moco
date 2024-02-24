Class {
	#name : #MocoOpenPonkOntoUmlSortalHelper,
	#superclass : #Object,
	#category : #'Moco-OpenPonk-Utils'
}

{ #category : #initialization }
MocoOpenPonkOntoUmlSortalHelper class >> initialize: aMocoSortal from: anOpenPonkSortal [
	aMocoSortal name: (anOpenPonkSortal name);
		abstract: (anOpenPonkSortal isAbstract).
		
	aMocoSortal attributes addAll: (MocoOpenPonkOntoUmlAttributeHelper getMocoAttributesFrom: anOpenPonkSortal).
]
