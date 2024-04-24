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

{ #category : #'private - transforming' }
MocoOpenPonkOntoUmlPartWholeAssociationTransformationRule >> transformAssociation: anOPUMLAssociation [
	"Sets the essential and inseparable constraints."
	
	| association |
	association := super transformAssociation: anOPUMLAssociation.
	
	association essential: (self checkIfEssential: anOPUMLAssociation);
		inseparable: (self checkIfInseparable: anOPUMLAssociation).
	
	^ association
]
