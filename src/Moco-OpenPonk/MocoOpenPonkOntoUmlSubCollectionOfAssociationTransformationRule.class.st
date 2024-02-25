"
Transforms OpenPonk’s SubCollectionOf OntoUML association to Moco’s counterpart.
"
Class {
	#name : #MocoOpenPonkOntoUmlSubCollectionOfAssociationTransformationRule,
	#superclass : #MocoOpenPonkOntoUmlPartWholeAssociationTransformationRule,
	#category : #'Moco-OpenPonk-Rule'
}

{ #category : #'private - accessing' }
MocoOpenPonkOntoUmlSubCollectionOfAssociationTransformationRule class >> modelClass [
	^ MocoOntoUmlSubCollectionOfAssociation
]

{ #category : #'private - accessing' }
MocoOpenPonkOntoUmlSubCollectionOfAssociationTransformationRule class >> stereotypeSelector [
	^ OntoUMLSubCollectionOf
]
