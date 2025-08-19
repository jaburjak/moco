"
Transforms OpenPonk’s Characterization OntoUML association into Moco’s counterpart.
"
Class {
	#name : 'MocoOpenPonkOntoUmlCharacterizationAssociationTransformationRule',
	#superclass : 'MocoOpenPonkOntoUmlSpecializedAssociationTransformationRule',
	#category : 'Moco-OpenPonk-Rule',
	#package : 'Moco-OpenPonk',
	#tag : 'Rule'
}

{ #category : 'private - accessing' }
MocoOpenPonkOntoUmlCharacterizationAssociationTransformationRule class >> modelClass [
	^ MocoOntoUmlCharacterizationAssociation
]

{ #category : 'private - accessing' }
MocoOpenPonkOntoUmlCharacterizationAssociationTransformationRule class >> stereotypeSelector [
	^ OntoUMLCharacterization
]

{ #category : 'private - processing' }
MocoOpenPonkOntoUmlCharacterizationAssociationTransformationRule >> transformAssociation: anOPUMLAssociation [
	"Reverses the association direction in case a Quality or Mode is not at the target end of the association."
	
	| association |
	association := super transformAssociation: anOPUMLAssociation.
	
	((association source element isKindOf: MocoOntoUmlQuality) or: [ association source element isKindOf: MocoOntoUmlMode ])
		ifTrue: [
			| tmp |
			tmp := association source.
			
			association source: (association target);
				target: tmp
		].
	
	^ association
]
