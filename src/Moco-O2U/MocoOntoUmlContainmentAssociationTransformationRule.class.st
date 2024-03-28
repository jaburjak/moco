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
MocoOntoUmlContainmentAssociationTransformationRule >> findWholeSide: aMocoUmlAssociation fromOriginal: aMocoOntoUmlContainmentAssociation [
	"Returns the side opposite of the Quantity."
	
	((aMocoOntoUmlContainmentAssociation source element isKindOf: MocoOntoUmlQuantity) and: [ (aMocoOntoUmlContainmentAssociation target element isKindOf: MocoOntoUmlQuantity) not ])
		ifTrue: [ ^ (aMocoUmlAssociation target) ].
	
	((aMocoOntoUmlContainmentAssociation target element isKindOf: MocoOntoUmlQuantity) and: [ (aMocoOntoUmlContainmentAssociation source element isKindOf: MocoOntoUmlQuantity) not ])
		ifTrue: [ ^ (aMocoUmlAssociation source) ].
	
	^ nil
]

{ #category : #'private - processing' }
MocoOntoUmlContainmentAssociationTransformationRule >> modifyAssociation: aMocoUmlAssociation fromOriginal: aMocoOntoUmlAssociation [
	"Makes the side opposite of the Quantity immutable."
	
	| wholeSide |
	wholeSide := (self findWholeSide: aMocoUmlAssociation fromOriginal: aMocoOntoUmlAssociation).

	wholeSide ifNotNil: [
		wholeSide frozen: true
	]
]

{ #category : #accessing }
MocoOntoUmlContainmentAssociationTransformationRule >> priority [
	^ 45
]
