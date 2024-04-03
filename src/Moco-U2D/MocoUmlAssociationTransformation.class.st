"
Contains utilities for transformation of UML associations.
"
Class {
	#name : #MocoUmlAssociationTransformation,
	#superclass : #Object,
	#category : #'Moco-U2D-Transformation'
}

{ #category : #processing }
MocoUmlAssociationTransformation class >> findReferencedSideOf: aMocoUmlAssociation [
	"Returns the referenced (target) side of the association."
	
	| referencing |
	referencing := self findReferencingSideOf: aMocoUmlAssociation.
	
	((aMocoUmlAssociation source) == referencing) ifTrue: [ ^ (aMocoUmlAssociation target) ].
	
	^ (aMocoUmlAssociation source)
]

{ #category : #processing }
MocoUmlAssociationTransformation class >> findReferencingSideOf: aMocoUmlAssociation [
	"Returns the referencing (source) side of the association."
	
	(aMocoUmlAssociation source multiplicity upper isMultiple)
		ifTrue: [ ^ (aMocoUmlAssociation source) ]. "many-to-one"
	
	(aMocoUmlAssociation target multiplicity upper isMultiple)
		ifTrue: [ ^ (aMocoUmlAssociation target) ]. "one-to-many"
	
	((aMocoUmlAssociation source multiplicity lower isOptional) and: [ aMocoUmlAssociation target multiplicity lower isMandatory ])
		ifTrue: [ ^ (aMocoUmlAssociation source) ]. "one[0..1]-to-one[1..1]"
	
	((aMocoUmlAssociation source multiplicity lower isMandatory) and: [ aMocoUmlAssociation target multiplicity lower isOptional ])
		ifTrue: [ ^ (aMocoUmlAssociation target) ]. "one[1..1]-to-one[0..1]"
	
	"one[0..0]-to-one[0..0] or one[1..1]-to-one[1..1]"
	
	(aMocoUmlAssociation target navigable) ifTrue: [ ^ (aMocoUmlAssociation source) ].
	
	(aMocoUmlAssociation source navigable) ifTrue: [ ^ (aMocoUmlAssociation target) ].
	
	^ (aMocoUmlAssociation source)
]
