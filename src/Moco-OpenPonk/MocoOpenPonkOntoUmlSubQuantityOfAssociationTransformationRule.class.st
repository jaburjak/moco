"
Transforms OpenPonk’s SubQuantityOf OntoUML association to Moco’s counterpart.
"
Class {
	#name : 'MocoOpenPonkOntoUmlSubQuantityOfAssociationTransformationRule',
	#superclass : 'MocoOpenPonkOntoUmlPartWholeAssociationTransformationRule',
	#category : 'Moco-OpenPonk-Rule',
	#package : 'Moco-OpenPonk',
	#tag : 'Rule'
}

{ #category : 'private - accessing' }
MocoOpenPonkOntoUmlSubQuantityOfAssociationTransformationRule class >> modelClass [
	^ MocoOntoUmlSubQuantityOfAssociation
]

{ #category : 'private - accessing' }
MocoOpenPonkOntoUmlSubQuantityOfAssociationTransformationRule class >> stereotypeSelector [
	^ OntoUMLSubQuantityOf
]
