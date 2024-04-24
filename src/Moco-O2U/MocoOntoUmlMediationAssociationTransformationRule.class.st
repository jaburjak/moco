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

{ #category : #accessing }
MocoOntoUmlMediationAssociationTransformationRule >> priority [
	^ 45
]

{ #category : #'private - transforming' }
MocoOntoUmlMediationAssociationTransformationRule >> toUmlAssociation: aMocoOntoUmlAssociation [
	"Makes the opposite side of the Relator immutable and ensures the association direction is from the Role to the Relator."
	
	| uml |
	uml := super toUmlAssociation: aMocoOntoUmlAssociation.
	
	(((aMocoOntoUmlAssociation source element isKindOf: MocoOntoUmlRelator) not) and: [ aMocoOntoUmlAssociation target element isKindOf: MocoOntoUmlRelator ])
		ifTrue: [
			uml source frozen: true
		].

	(((aMocoOntoUmlAssociation target element isKindOf: MocoOntoUmlRelator) not) and: [ aMocoOntoUmlAssociation source element isKindOf: MocoOntoUmlRelator ])
		ifTrue: [
			uml target frozen: true
		].

	(((aMocoOntoUmlAssociation source element isKindOf: MocoOntoUmlRole) not) and: [ aMocoOntoUmlAssociation target element isKindOf: MocoOntoUmlRole ])
		ifTrue: [
			| tmp |
			tmp := uml source.
			
			uml source: (uml target);
				target: tmp
		].
	
	^ uml
]
