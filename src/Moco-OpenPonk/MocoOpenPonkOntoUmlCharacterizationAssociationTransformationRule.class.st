"
Transforms OpenPonk’s Characterization OntoUML association into Moco’s counterpart.
"
Class {
	#name : #MocoOpenPonkOntoUmlCharacterizationAssociationTransformationRule,
	#superclass : #MocoOpenPonkOntoUmlSpecializedAssociationTransformationRule,
	#category : #'Moco-OpenPonk-Rule'
}

{ #category : #'private - accessing' }
MocoOpenPonkOntoUmlCharacterizationAssociationTransformationRule class >> modelClass [
	^ MocoOntoUmlCharacterizationAssociation
]

{ #category : #'private - accessing' }
MocoOpenPonkOntoUmlCharacterizationAssociationTransformationRule class >> stereotypeSelector [
	^ OntoUMLCharacterization
]
