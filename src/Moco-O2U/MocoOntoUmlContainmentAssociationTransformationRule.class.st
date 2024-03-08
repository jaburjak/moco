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
	((aMocoOntoUmlContainmentAssociation source element isKindOf: MocoOntoUmlQuantity) and: [ (aMocoOntoUmlContainmentAssociation target element isKindOf: MocoOntoUmlQuantity) not ])
		ifTrue: [ ^ (aMocoUmlAssociation source) ].
	
	^ nil
]

{ #category : #'private - processing' }
MocoOntoUmlContainmentAssociationTransformationRule >> modifyAssociation: aMocoUmlAssociation fromOriginal: aMocoWrappedElement [
	| partSide |
	partSide := (self findPartSide: aMocoUmlAssociation fromOriginal: (aMocoWrappedElement innerElement)).

	(partSide isNotNil)
		ifTrue: [
			partSide frozen: true.
		]
]

{ #category : #accessing }
MocoOntoUmlContainmentAssociationTransformationRule >> priority [
	^ 45
]
