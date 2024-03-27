"
Transforms OntoUML Material relationship into UML.
"
Class {
	#name : #MocoOntoUmlMaterialAssociationTransformationRule,
	#superclass : #MocoOntoUmlAssociationTransformationRule,
	#category : #'Moco-O2U-Rule'
}

{ #category : #'private - accessing' }
MocoOntoUmlMaterialAssociationTransformationRule class >> modelSelector [
	^ MocoOntoUmlMaterialAssociation
]

{ #category : #'private - processing' }
MocoOntoUmlMaterialAssociationTransformationRule >> modifyAssociation: aMocoUmlAssociation fromOriginal: aMocoOntoUmlAssociation [
	"Discards material associations from the model."
	
	^ false
]

{ #category : #accessing }
MocoOntoUmlMaterialAssociationTransformationRule >> priority [
	^ 45
]
