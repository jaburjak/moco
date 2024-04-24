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

{ #category : #accessing }
MocoOntoUmlMaterialAssociationTransformationRule >> priority [
	^ 45
]

{ #category : #'private - transforming' }
MocoOntoUmlMaterialAssociationTransformationRule >> toUmlAssociation: aMocoOntoUmlAssociation [
	"Discards material associations from the model."
	
	^ nil
]
