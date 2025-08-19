"
Transforms OpenPonk’s Containment OntoUML association into Moco’s counterpart.
"
Class {
	#name : 'MocoOpenPonkOntoUmlContainmentAssociationTransformationRule',
	#superclass : 'MocoOpenPonkOntoUmlSpecializedAssociationTransformationRule',
	#category : 'Moco-OpenPonk-Rule',
	#package : 'Moco-OpenPonk',
	#tag : 'Rule'
}

{ #category : 'private - accessing' }
MocoOpenPonkOntoUmlContainmentAssociationTransformationRule class >> modelClass [
	^ MocoOntoUmlContainmentAssociation
]

{ #category : 'private - accessing' }
MocoOpenPonkOntoUmlContainmentAssociationTransformationRule class >> stereotypeSelector [
	^ OntoUMLContainment
]
