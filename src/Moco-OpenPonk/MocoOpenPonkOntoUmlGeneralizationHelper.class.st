"
Helper for transforming generalizations.
"
Class {
	#name : #MocoOpenPonkOntoUmlGeneralizationHelper,
	#superclass : #Object,
	#instVars : [
		'engine'
	],
	#category : #'Moco-OpenPonk-Utils'
}

{ #category : #'private - selecting' }
MocoOpenPonkOntoUmlGeneralizationHelper class >> extractGeneralizationsFrom: anOpenPonkOntoUmlClass [
	| generalizations |
	generalizations := OrderedCollection new.
	
	(anOpenPonkOntoUmlClass class canUnderstand: #generalizations) ifTrue: [
		generalizations addAll: (anOpenPonkOntoUmlClass generalizations)
	].
	
	^ generalizations
]

{ #category : #'instance creation' }
MocoOpenPonkOntoUmlGeneralizationHelper class >> new [
	self error: 'Send withEngine: to create an instance.'
]

{ #category : #'instance creation' }
MocoOpenPonkOntoUmlGeneralizationHelper class >> withEngine: anEngine [
	| inst |
	inst := self basicNew.
	
	inst engine: anEngine.
	
	^ inst
]

{ #category : #'private - accessing' }
MocoOpenPonkOntoUmlGeneralizationHelper >> engine: anEngine [
	engine := anEngine
]

{ #category : #transforming }
MocoOpenPonkOntoUmlGeneralizationHelper >> getMocoGeneralizationsFrom: anOpenPonkOntoUmlClass [
	| op |
	op := self class extractGeneralizationsFrom: anOpenPonkOntoUmlClass.
	
	^ op collect: [ :each | self toMocoGeneralization: each ]
]

{ #category : #'private - transforming' }
MocoOpenPonkOntoUmlGeneralizationHelper >> toMocoGeneralization: anOpenPonkGeneralization [
	| moco |
	moco := MocoOntoUmlGeneralization new.
	
	moco supertype: ((engine findOutElementsFor: (anOpenPonkGeneralization general)) first innerElement);
		subtype: ((engine findOutElementsFor: (anOpenPonkGeneralization specific)) first innerElement).
	
	^ moco
]
