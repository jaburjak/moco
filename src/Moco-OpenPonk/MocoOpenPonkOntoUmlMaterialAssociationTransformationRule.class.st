"
Transforms OpenPonk’s Material OntoUML relationship into Moco’s counterpart.
"
Class {
	#name : 'MocoOpenPonkOntoUmlMaterialAssociationTransformationRule',
	#superclass : 'MocoOpenPonkOntoUmlSpecializedAssociationTransformationRule',
	#category : 'Moco-OpenPonk-Rule',
	#package : 'Moco-OpenPonk',
	#tag : 'Rule'
}

{ #category : 'private - accessing' }
MocoOpenPonkOntoUmlMaterialAssociationTransformationRule class >> modelClass [
	^ MocoOntoUmlMaterialAssociation
]

{ #category : 'private - accessing' }
MocoOpenPonkOntoUmlMaterialAssociationTransformationRule class >> stereotypeSelector [
	^ OntoUMLMaterial
]
