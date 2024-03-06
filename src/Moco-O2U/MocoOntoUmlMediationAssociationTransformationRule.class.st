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
MocoOntoUmlMediationAssociationTransformationRule >> modifyAssociation: aMocoUmlAssociation fromOriginal: aMocoWrappedElement onEngine: anEngine [
	(((aMocoWrappedElement innerElement source element isKindOf: MocoOntoUmlRelator) not) and: [ aMocoWrappedElement innerElement target element isKindOf: MocoOntoUmlRelator ])
		ifTrue: [
			aMocoUmlAssociation source frozen: true
		].

	(((aMocoWrappedElement innerElement target element isKindOf: MocoOntoUmlRelator) not) and: [ aMocoWrappedElement innerElement source element isKindOf: MocoOntoUmlRelator ])
		ifTrue: [
			aMocoUmlAssociation target frozen: true
		].

	(((aMocoWrappedElement innerElement source element isKindOf: MocoOntoUmlRole) not) and: [ aMocoWrappedElement innerElement target element isKindOf: MocoOntoUmlRole ])
		ifTrue: [
			| tmp |
			tmp := aMocoUmlAssociation source.
			
			aMocoUmlAssociation source: (aMocoUmlAssociation target);
				target: tmp
		].
]

{ #category : #accessing }
MocoOntoUmlMediationAssociationTransformationRule >> priority [
	^ 45
]
