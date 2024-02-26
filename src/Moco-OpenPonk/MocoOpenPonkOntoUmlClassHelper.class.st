"
Helper for transforming OntoUML classes.
"
Class {
	#name : #MocoOpenPonkOntoUmlClassHelper,
	#superclass : #Object,
	#category : #'Moco-OpenPonk-Utils'
}

{ #category : #initialization }
MocoOpenPonkOntoUmlClassHelper class >> initialize: aMocoClass from: anOpenPonkClass [
	aMocoClass name: (anOpenPonkClass name);
		abstract: (anOpenPonkClass isAbstract).
		
	aMocoClass attributes addAll: (MocoOpenPonkOntoUmlAttributeHelper getMocoAttributesFrom: anOpenPonkClass).
]
