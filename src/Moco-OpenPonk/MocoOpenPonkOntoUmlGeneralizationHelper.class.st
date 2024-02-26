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
	
	^ op flatCollect: [ :each | self toMocoGeneralization: each ]
]

{ #category : #'private - transforming' }
MocoOpenPonkOntoUmlGeneralizationHelper >> toMocoGeneralization: anOpenPonkGeneralization [
	| coll moco |
	coll := OrderedCollection new.
	moco := MocoOntoUmlGeneralization new.
	
	moco supertype: ((engine findOutElementsFor: (anOpenPonkGeneralization general)) first innerElement);
		subtype: ((engine findOutElementsFor: (anOpenPonkGeneralization specific)) first innerElement).
	
	coll add: moco.
	
	anOpenPonkGeneralization generalizationSets do: [ :each |
		| set |
		set := engine outModel elements select: [ :e | (e innerElement isKindOf: MocoOntoUmlGeneralizationSet) and: [ (e innerElement name) = (each name) ] ].
		set := set ifEmpty: [ nil ] ifNotEmpty: [ set first innerElement ].
		
		set ifNil: [
			set := MocoOntoUmlGeneralizationSet new.
			set name: (each name);
				disjoint: (each isDisjoint);
				covering: (each isCovering).
				
			coll add: set.
		].
	
		set members add: moco.
	].
	
	^ coll
]
