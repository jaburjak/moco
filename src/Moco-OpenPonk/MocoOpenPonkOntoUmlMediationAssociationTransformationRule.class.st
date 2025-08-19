"
Transforms OpenPonk’s Mediation OntoUML relationship into Moco’s counterpart.
"
Class {
	#name : 'MocoOpenPonkOntoUmlMediationAssociationTransformationRule',
	#superclass : 'MocoOpenPonkOntoUmlSpecializedAssociationTransformationRule',
	#category : 'Moco-OpenPonk-Rule',
	#package : 'Moco-OpenPonk',
	#tag : 'Rule'
}

{ #category : 'private - accessing' }
MocoOpenPonkOntoUmlMediationAssociationTransformationRule class >> modelClass [
	^ MocoOntoUmlMediationAssociation
]

{ #category : 'private - accessing' }
MocoOpenPonkOntoUmlMediationAssociationTransformationRule class >> stereotypeSelector [
	^ OntoUMLMediation
]
