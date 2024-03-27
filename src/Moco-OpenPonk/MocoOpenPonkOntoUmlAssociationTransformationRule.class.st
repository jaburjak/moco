"
Transforms OpenPonk’s OntoUML association to a Moco OntoUML association.
"
Class {
	#name : #MocoOpenPonkOntoUmlAssociationTransformationRule,
	#superclass : #MocoTransformationRule,
	#instVars : [
		'transformation'
	],
	#category : #'Moco-OpenPonk-Rule'
}

{ #category : #transforming }
MocoOpenPonkOntoUmlAssociationTransformationRule >> execute [
	| associations |
	associations := engine input
		selectElementsOfKind: OPUMLAssociation
		ofStereotype: nil
		notGuarded: #MocoOpenPonkOntoUmlAssociationTransformationRule.
	
	associations do: [ :each | self transformAssociation: each ]
]

{ #category : #initialization }
MocoOpenPonkOntoUmlAssociationTransformationRule >> initialize [
	super initialize.
	
	transformation := MocoOpenPonkOntoUmlAssociationTransformation engine: engine
]

{ #category : #accessing }
MocoOpenPonkOntoUmlAssociationTransformationRule >> priority [
	^ 51
]

{ #category : #'private - transforming' }
MocoOpenPonkOntoUmlAssociationTransformationRule >> transformAssociation: anOPUMLAssociation [
	"Transforms the given association into a Moco OntoUML association."
	
	| association |
	association := MocoOntoUmlAssociation new.
	
	transformation initialize: association from: anOPUMLAssociation.
	
	engine addOutputElement: association withSource: anOPUMLAssociation.
	engine input guard: anOPUMLAssociation with: #MocoOpenPonkOntoUmlAssociationTransformationRule
]
