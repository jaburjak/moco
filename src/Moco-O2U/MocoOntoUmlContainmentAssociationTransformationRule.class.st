"
Transforms OntoUML Containment relationship into a UML association.
"
Class {
	#name : #MocoOntoUmlContainmentAssociationTransformationRule,
	#superclass : #MocoOntoUmlAssociationTransformationRule,
	#category : #'Moco-O2U-Rule'
}

{ #category : #'private - accessing' }
MocoOntoUmlContainmentAssociationTransformationRule class >> modelSelector [
	^ MocoOntoUmlContainmentAssociation
]

{ #category : #'private - processing' }
MocoOntoUmlContainmentAssociationTransformationRule >> findPartSide: aMocoUmlAssociation fromOriginal: aMocoOntoUmlContainmentAssociation [
	"Returns the side of the Quantity."
	
	((aMocoOntoUmlContainmentAssociation source element isKindOf: MocoOntoUmlQuantity) and: [ (aMocoOntoUmlContainmentAssociation target element isKindOf: MocoOntoUmlQuantity) not ])
		ifTrue: [ ^ (aMocoUmlAssociation source) ].
	
	((aMocoOntoUmlContainmentAssociation target element isKindOf: MocoOntoUmlQuantity) and: [ (aMocoOntoUmlContainmentAssociation source element isKindOf: MocoOntoUmlQuantity) not ])
		ifTrue: [ ^ (aMocoUmlAssociation target) ].
	
	^ nil
]

{ #category : #'private - processing' }
MocoOntoUmlContainmentAssociationTransformationRule >> modifyAssociation: aMocoUmlAssociation fromOriginal: aMocoOntoUmlAssociation [
	"Makes the side of the Quantity immutable."
	
	| partSide |
	partSide := (self findPartSide: aMocoUmlAssociation fromOriginal: aMocoOntoUmlAssociation).

	partSide ifNotNil: [
		partSide frozen: true
	]
]

{ #category : #accessing }
MocoOntoUmlContainmentAssociationTransformationRule >> priority [
	^ 45
]
