"
Base class for transforming OpenPonk’s part-whole associations into their Moco alternatives.
"
Class {
	#name : #MocoOpenPonkOntoUmlPartWholeAssociationTransformationRule,
	#superclass : #MocoOpenPonkOntoUmlSpecializedAssociationTransformationRule,
	#category : #'Moco-OpenPonk-Rule'
}

{ #category : #'instance creation' }
MocoOpenPonkOntoUmlPartWholeAssociationTransformationRule class >> newWithEngine: anEngine [
	(self asString = 'MocoOpenPonkOntoUmlPartWholeAssociationTransformationRule') ifTrue: [ ^ self subclassResponsibility ] ifFalse: [ ^ super newWithEngine: anEngine ]
]

{ #category : #'private - testing' }
MocoOpenPonkOntoUmlPartWholeAssociationTransformationRule >> checkIfEssential: anOPUMLAssociation [
	"Returns true if the association is marked as essential."
	
	^ anOPUMLAssociation appliedStereotypes first essential
]

{ #category : #'private - testing' }
MocoOpenPonkOntoUmlPartWholeAssociationTransformationRule >> checkIfInseparable: anOPUMLAssociation [
	"Returns true if the association is marked as inseparable."
	
	^ anOPUMLAssociation appliedStereotypes first inseparable
]

{ #category : #transforming }
MocoOpenPonkOntoUmlPartWholeAssociationTransformationRule >> execute [
	| associations |
	associations := engine input
		selectElementsOfKind: OPUMLAssociation
		ofStereotype: (self class stereotypeSelector ifNil: [ nil ] ifNotNil: [ self class stereotypeSelector asString ])
		notGuarded: #MocoOpenPonkOntoUmlPartWholeAssociationTransformationRule.
	
	associations do: [ :each | self transformAssociation: each ]
]

{ #category : #'private - transforming' }
MocoOpenPonkOntoUmlPartWholeAssociationTransformationRule >> transformAssociation: anOPUMLAssociation [
	"Transforms the OpenPonk association to a Moco association."
	
	| association |
	association := (self class modelClass) new.
	
	transformation initialize: association from: anOPUMLAssociation.
	
	association essential: (self checkIfEssential: anOPUMLAssociation);
		inseparable: (self checkIfInseparable: anOPUMLAssociation).	
	
	self modifyAssociation: association.
		
	engine addOutputElement: association withSource: anOPUMLAssociation.
	engine input guard: anOPUMLAssociation with: #MocoOpenPonkOntoUmlPartWholeAssociationTransformationRule;
		guard: anOPUMLAssociation with: #MocoOpenPonkOntoUmlSpecializedAssociationTransformationRule
]
