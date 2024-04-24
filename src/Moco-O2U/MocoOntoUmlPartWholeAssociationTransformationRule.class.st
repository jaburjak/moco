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
	"Returns the part side of the association."
	
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
	"Returns the whole side of the association."
	
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

{ #category : #accessing }
MocoOntoUmlPartWholeAssociationTransformationRule >> priority [
	^ 44
]

{ #category : #'private - transforming' }
MocoOntoUmlPartWholeAssociationTransformationRule >> toUmlAssociation: aMocoOntoUmlAssociation [
	"Transforms essential and inseparable relationship stereotypes to appropriate immutability constraints."
	
	| uml partSide wholeSide |
	uml := super toUmlAssociation: aMocoOntoUmlAssociation.
	
	partSide := (self findPartSide: uml fromOriginal: aMocoOntoUmlAssociation).
	wholeSide := (self findWholeSide: uml fromOriginal: aMocoOntoUmlAssociation).

	((partSide isNotNil) and: [ aMocoOntoUmlAssociation essential ])
		ifTrue: [
			partSide frozen: true.
		].
	
	((wholeSide isNotNil) and: [ aMocoOntoUmlAssociation inseparable ])
		ifTrue: [
			wholeSide frozen: true.
		].
	
	^ uml
]
