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
MocoOntoUmlPartWholeAssociationTransformationRule >> modifyAssociation: aMocoUmlAssociation fromOriginal: aMocoWrappedElement onEngine: anEngine [
	| partSide wholeSide |
	partSide := nil.
	wholeSide := nil.
	
	((aMocoWrappedElement innerElement source shareability type isNotNil) and: [ aMocoWrappedElement innerElement target shareability type isNil ])
		ifTrue: [
			partSide := aMocoUmlAssociation source.
			wholeSide := aMocoUmlAssociation target
		].
	
	((aMocoWrappedElement innerElement source shareability type isNil) and: [ aMocoWrappedElement innerElement target shareability type isNotNil ])
		ifTrue: [
			partSide := aMocoUmlAssociation target.
			wholeSide := aMocoUmlAssociation source
		].

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
