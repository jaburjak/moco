Class {
	#name : #MocoOpenPonkOntoUmlAssociationHelper,
	#superclass : #Object,
	#instVars : [
		'engine'
	],
	#category : #'Moco-OpenPonk-Utils'
}

{ #category : #'instance creation' }
MocoOpenPonkOntoUmlAssociationHelper class >> new [
	self error: 'Use withEngine: message instead of new.'
]

{ #category : #'instance creation' }
MocoOpenPonkOntoUmlAssociationHelper class >> withEngine: anEngine [
	| inst |
	inst := self basicNew.
	
	inst engine: anEngine.
	
	^ inst
]

{ #category : #'private - accessing' }
MocoOpenPonkOntoUmlAssociationHelper >> engine: anEngine [
	engine := anEngine
]

{ #category : #transforming }
MocoOpenPonkOntoUmlAssociationHelper >> initialize: anAssociation from: anOpenPonkAssociation [
	anAssociation name: anOpenPonkAssociation name;
		derived: anOpenPonkAssociation isDerived;
		source: (self toMocoSide: anOpenPonkAssociation memberEnds first);
		target: (self toMocoSide: anOpenPonkAssociation memberEnds second).
		
	^ anAssociation
]

{ #category : #'private - transforming' }
MocoOpenPonkOntoUmlAssociationHelper >> toMocoSide: aProperty [
	| moco |
	moco := MocoOntoUmlAssociationSide new.
	
	moco name: aProperty name;
		element: (engine findOutElementsFor: aProperty type) first innerElement;
		visibility: (MocoOpenPonkOntoUmlVisibilityHelper toMocoVisibility: aProperty visibility);
		shareability: (MocoOpenPonkOntoUmlShareabilityHelper toMocoShareability: aProperty aggregation).
		
	((aProperty lowerValue isNil) and: (aProperty upperValue isNil))
		ifTrue: [
			moco multiplicity lower value: 1. moco multiplicity upper value: 1
		]
		ifFalse: [
			moco multiplicity lower: (MocoUmlMultiplicityBound value: (aProperty lowerValue value)).
			moco multiplicity upper: (MocoUmlMultiplicityBound value: (aProperty upperValue value)).
		].
	
	^ moco
]
