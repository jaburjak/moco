"
Base class for transforming OpenPonk’s specialized associations into their Moco alternatives.
"
Class {
	#name : #MocoOpenPonkOntoUmlSpecializedAssociationTransformationRule,
	#superclass : #MocoTransformationRule,
	#instVars : [
		'transformation'
	],
	#category : #'Moco-OpenPonk-Rule'
}

{ #category : #'private - accessing' }
MocoOpenPonkOntoUmlSpecializedAssociationTransformationRule class >> modelClass [
	^ self subclassResponsibility
]

{ #category : #'instance creation' }
MocoOpenPonkOntoUmlSpecializedAssociationTransformationRule class >> newWithEngine: anEngine [
	(self asString = 'MocoOpenPonkOntoUmlSpecializedAssociationTransformationRule') ifTrue: [ ^ self subclassResponsibility ] ifFalse: [ ^ super newWithEngine: anEngine ]
]

{ #category : #'private - accessing' }
MocoOpenPonkOntoUmlSpecializedAssociationTransformationRule class >> stereotypeSelector [
	^ self subclassResponsibility
]

{ #category : #transforming }
MocoOpenPonkOntoUmlSpecializedAssociationTransformationRule >> execute [
	| associations |
	associations := engine input
		selectElementsOfKind: OPUMLAssociation
		ofStereotype: (self class stereotypeSelector ifNil: [ nil ] ifNotNil: [ self class stereotypeSelector asString ])
		notGuarded: #MocoOpenPonkOntoUmlSpecializedAssociationTransformationRule.
	
	associations do: [ :each | self transformAssociation: each ]
]

{ #category : #initialization }
MocoOpenPonkOntoUmlSpecializedAssociationTransformationRule >> initialize [
	super initialize.
	
	transformation := MocoOpenPonkOntoUmlAssociationTransformation engine: engine
]

{ #category : #'private - processing' }
MocoOpenPonkOntoUmlSpecializedAssociationTransformationRule >> modifyAssociation: aMocoOntoUmlAssociation [
	"Modifies the given association based on the concrete class of the transformation rule."
]

{ #category : #accessing }
MocoOpenPonkOntoUmlSpecializedAssociationTransformationRule >> priority [
	^ 50
]

{ #category : #'private - transforming' }
MocoOpenPonkOntoUmlSpecializedAssociationTransformationRule >> transformAssociation: anOPUMLAssociation [
	"Transforms the given association into a Moco OntoUML association."
	
	| association |
	association := (self class modelClass) new.
	
	transformation initialize: association from: anOPUMLAssociation.
	
	self modifyAssociation: association.
	
	engine addOutputElement: association withSource: anOPUMLAssociation.
	engine input guard: anOPUMLAssociation with: #MocoOpenPonkOntoUmlSpecializedAssociationTransformationRule
]
