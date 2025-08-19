"
Transforms OpenPonk’s Formal OntoUML relationship into Moco’s counterpart.
"
Class {
	#name : 'MocoOpenPonkOntoUmlFormalAssociationTransformationRule',
	#superclass : 'MocoOpenPonkOntoUmlSpecializedAssociationTransformationRule',
	#category : 'Moco-OpenPonk-Rule',
	#package : 'Moco-OpenPonk',
	#tag : 'Rule'
}

{ #category : 'private - accessing' }
MocoOpenPonkOntoUmlFormalAssociationTransformationRule class >> modelClass [
	^ MocoOntoUmlFormalAssociation
]

{ #category : 'private - accessing' }
MocoOpenPonkOntoUmlFormalAssociationTransformationRule class >> stereotypeSelector [
	^ OntoUMLDomainFormal
]
