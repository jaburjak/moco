"
Transforms OntoUML Containment relationship into a UML association.
"
Class {
	#name : #MocoOntoUmlContainmentAssociationTransformationRule,
	#superclass : #MocoOntoUmlPartWholeAssociationTransformationRule,
	#category : #'Moco-O2U-Rule'
}

{ #category : #'private - accessing' }
MocoOntoUmlContainmentAssociationTransformationRule class >> modelSelector [
	^ MocoOntoUmlContainmentAssociation
]

{ #category : #'private - processing' }
MocoOntoUmlContainmentAssociationTransformationRule >> findPartSide: aMocoUmlAssociation fromOriginal: aMocoOntoUmlContainmentAssociation [
	"Returns the side of the Quantity."
	
	| whole |
	whole := self findWholeSide: aMocoUmlAssociation fromOriginal: aMocoOntoUmlContainmentAssociation.
	
	whole ifNil: [ ^ nil ].
	
	^ (whole == aMocoUmlAssociation source)
		ifTrue: [ aMocoUmlAssociation target ]
		ifFalse: [ aMocoUmlAssociation source ]
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

{ #category : #accessing }
MocoOntoUmlContainmentAssociationTransformationRule >> priority [
	^ 45
]

{ #category : #'private - transforming' }
MocoOntoUmlContainmentAssociationTransformationRule >> toUmlAssociation: aMocoOntoUmlAssociation [
	"Makes the side opposite of the Quantity immutable."
	
	| uml wholeSide |
	uml := super toUmlAssociation: aMocoOntoUmlAssociation.
	
	wholeSide := (self findWholeSide: uml fromOriginal: aMocoOntoUmlAssociation).

	wholeSide ifNotNil: [
		wholeSide frozen: true
	].

	^ uml
]
