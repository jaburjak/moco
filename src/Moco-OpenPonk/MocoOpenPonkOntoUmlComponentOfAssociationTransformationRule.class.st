"
Transforms OpenPonk’s ComponentOf OntoUML association to Moco’s counterpart.
"
Class {
	#name : 'MocoOpenPonkOntoUmlComponentOfAssociationTransformationRule',
	#superclass : 'MocoOpenPonkOntoUmlPartWholeAssociationTransformationRule',
	#category : 'Moco-OpenPonk-Rule',
	#package : 'Moco-OpenPonk',
	#tag : 'Rule'
}

{ #category : 'private - accessing' }
MocoOpenPonkOntoUmlComponentOfAssociationTransformationRule class >> modelClass [
	^ MocoOntoUmlComponentOfAssociation
]

{ #category : 'private - accessing' }
MocoOpenPonkOntoUmlComponentOfAssociationTransformationRule class >> stereotypeSelector [
	^ OntoUMLComponentOf
]
