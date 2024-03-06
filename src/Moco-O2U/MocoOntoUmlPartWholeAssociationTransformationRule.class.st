"
Transforms OntoUML Part-Whole relationships into UML associations.
"
Class {
	#name : #MocoOntoUmlPartWholeAssociationTransformationRule,
	#superclass : #MocoOntoUmlAssociationTransformationRule,
	#category : #'Moco-O2U-Rule'
}

{ #category : #'private - accessing' }
MocoOntoUmlPartWholeAssociationTransformationRule class >> modelSelector [
	^ MocoOntoUmlPartWholeAssociation
]

{ #category : #'private - processing' }
MocoOntoUmlPartWholeAssociationTransformationRule >> findPartSide: aMocoUmlAssociation fromOriginal: aMocoOntoUmlPartWholeAssociation [
	((aMocoOntoUmlPartWholeAssociation source shareability type isNotNil) and: [ aMocoOntoUmlPartWholeAssociation target shareability type isNil ])
		ifTrue: [
			^ aMocoUmlAssociation source
		].
	
	((aMocoOntoUmlPartWholeAssociation source shareability type isNil) and: [ aMocoOntoUmlPartWholeAssociation target shareability type isNotNil ])
		ifTrue: [
			^ aMocoUmlAssociation target
		].
	
	^ nil
]

{ #category : #'private - processing' }
MocoOntoUmlPartWholeAssociationTransformationRule >> findWholeSide: aMocoUmlAssociation fromOriginal: aMocoOntoUmlPartWholeAssociation [
	((aMocoOntoUmlPartWholeAssociation source shareability type isNotNil) and: [ aMocoOntoUmlPartWholeAssociation target shareability type isNil ])
		ifTrue: [
			^ aMocoUmlAssociation target
		].
	
	((aMocoOntoUmlPartWholeAssociation source shareability type isNil) and: [ aMocoOntoUmlPartWholeAssociation target shareability type isNotNil ])
		ifTrue: [
			^ aMocoUmlAssociation source
		].
	
	^ nil
]

{ #category : #'private - processing' }
MocoOntoUmlPartWholeAssociationTransformationRule >> modifyAssociation: aMocoUmlAssociation fromOriginal: aMocoWrappedElement onEngine: anEngine [
	| partSide wholeSide |
	partSide := (self findPartSide: aMocoUmlAssociation fromOriginal: (aMocoWrappedElement innerElement)).
	wholeSide := (self findWholeSide: aMocoUmlAssociation fromOriginal: (aMocoWrappedElement innerElement)).

	((partSide isNotNil) and: [ aMocoWrappedElement innerElement essential ])
		ifTrue: [
			partSide frozen: true.
		].
	
	((wholeSide isNotNil) and: [ aMocoWrappedElement innerElement inseparable ])
		ifTrue: [
			wholeSide frozen: true.
		]
]

{ #category : #accessing }
MocoOntoUmlPartWholeAssociationTransformationRule >> priority [
	^ 44
]
