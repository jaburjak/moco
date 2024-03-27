"
Transforms OntoUML Mediation associations to UML.
"
Class {
	#name : #MocoOntoUmlMediationAssociationTransformationRule,
	#superclass : #MocoOntoUmlAssociationTransformationRule,
	#category : #'Moco-O2U-Rule'
}

{ #category : #'private - accessing' }
MocoOntoUmlMediationAssociationTransformationRule class >> modelSelector [
	^ MocoOntoUmlMediationAssociation
]

{ #category : #'private - processing' }
MocoOntoUmlMediationAssociationTransformationRule >> modifyAssociation: aMocoUmlAssociation fromOriginal: aMocoOntoUmlAssociation [
	"Makes the opposite side of the Relator immutable and ensures the association direction is from the Role to the Relator."
	
	(((aMocoOntoUmlAssociation source element isKindOf: MocoOntoUmlRelator) not) and: [ aMocoOntoUmlAssociation target element isKindOf: MocoOntoUmlRelator ])
		ifTrue: [
			aMocoUmlAssociation source frozen: true
		].

	(((aMocoOntoUmlAssociation target element isKindOf: MocoOntoUmlRelator) not) and: [ aMocoOntoUmlAssociation source element isKindOf: MocoOntoUmlRelator ])
		ifTrue: [
			aMocoUmlAssociation target frozen: true
		].

	(((aMocoOntoUmlAssociation source element isKindOf: MocoOntoUmlRole) not) and: [ aMocoOntoUmlAssociation target element isKindOf: MocoOntoUmlRole ])
		ifTrue: [
			| tmp |
			tmp := aMocoUmlAssociation source.
			
			aMocoUmlAssociation source: (aMocoUmlAssociation target);
				target: tmp
		]
]

{ #category : #accessing }
MocoOntoUmlMediationAssociationTransformationRule >> priority [
	^ 45
]
