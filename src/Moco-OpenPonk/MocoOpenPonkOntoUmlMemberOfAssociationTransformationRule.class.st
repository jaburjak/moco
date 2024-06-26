"
Transforms OpenPonk’s MemberOf OntoUML association to Moco’s counterpart.
"
Class {
	#name : #MocoOpenPonkOntoUmlMemberOfAssociationTransformationRule,
	#superclass : #MocoOpenPonkOntoUmlPartWholeAssociationTransformationRule,
	#category : #'Moco-OpenPonk-Rule'
}

{ #category : #'private - accessing' }
MocoOpenPonkOntoUmlMemberOfAssociationTransformationRule class >> modelClass [
	^ MocoOntoUmlMemberOfAssociation
]

{ #category : #'private - accessing' }
MocoOpenPonkOntoUmlMemberOfAssociationTransformationRule class >> stereotypeSelector [
	^ OntoUMLMemberOf
]
