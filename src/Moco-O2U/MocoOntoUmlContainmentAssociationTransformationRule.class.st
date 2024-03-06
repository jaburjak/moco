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
MocoOntoUmlContainmentAssociationTransformationRule >> findPartSide: aMocoUmlAssociation fromOriginal: aMocoOntoUmlPartWholeAssociation [
	| part |
	part := super findPartSide: aMocoUmlAssociation fromOriginal: aMocoOntoUmlPartWholeAssociation.
	
	part ifNotNil: [ ^ part ].
	
	((aMocoOntoUmlPartWholeAssociation source element isKindOf: MocoOntoUmlQuantity) and: [ (aMocoOntoUmlPartWholeAssociation target element isKindOf: MocoOntoUmlQuantity) not ])
		ifTrue: [ ^ (aMocoUmlAssociation source) ].
	
	^ nil
]

{ #category : #'private - processing' }
MocoOntoUmlContainmentAssociationTransformationRule >> findWholeSide: aMocoUmlAssociation fromOriginal: aMocoOntoUmlPartWholeAssociation [
	| whole |
	whole := super findWholeSide: aMocoUmlAssociation fromOriginal: aMocoOntoUmlPartWholeAssociation.
	
	whole ifNotNil: [ ^ whole ].
	
	((aMocoOntoUmlPartWholeAssociation source element isKindOf: MocoOntoUmlQuantity) and: [ (aMocoOntoUmlPartWholeAssociation target element isKindOf: MocoOntoUmlQuantity) not ])
		ifTrue: [ ^ (aMocoUmlAssociation target) ].
	
	^ nil
]

{ #category : #accessing }
MocoOntoUmlContainmentAssociationTransformationRule >> priority [
	^ 45
]
