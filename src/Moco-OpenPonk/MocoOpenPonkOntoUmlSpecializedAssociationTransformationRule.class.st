"
Base class for transforming OpenPonk’s specialized associations into their Moco alternatives.
"
Class {
	#name : 'MocoOpenPonkOntoUmlSpecializedAssociationTransformationRule',
	#superclass : 'MocoOpenPonkOntoUmlAssociationTransformationRule',
	#category : 'Moco-OpenPonk-Rule',
	#package : 'Moco-OpenPonk',
	#tag : 'Rule'
}

{ #category : 'private - accessing' }
MocoOpenPonkOntoUmlSpecializedAssociationTransformationRule class >> modelClass [
	^ self subclassResponsibility
]

{ #category : 'instance creation' }
MocoOpenPonkOntoUmlSpecializedAssociationTransformationRule class >> newWithEngine: anEngine [
	(self asString = 'MocoOpenPonkOntoUmlSpecializedAssociationTransformationRule') ifTrue: [ ^ self subclassResponsibility ] ifFalse: [ ^ super newWithEngine: anEngine ]
]

{ #category : 'private - accessing' }
MocoOpenPonkOntoUmlSpecializedAssociationTransformationRule class >> stereotypeSelector [
	^ self subclassResponsibility
]

{ #category : 'accessing' }
MocoOpenPonkOntoUmlSpecializedAssociationTransformationRule >> priority [
	^ 50
]
