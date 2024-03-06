"
Transforms OntoUML Characterization relationship into a UML association.
"
Class {
	#name : #MocoOntoUmlCharacterizationAssociationTransformationRule,
	#superclass : #MocoOntoUmlAssociationTransformationRule,
	#category : #'Moco-O2U-Rule'
}

{ #category : #'private - processing' }
MocoOntoUmlCharacterizationAssociationTransformationRule >> modifyAssociation: aMocoUmlAssociation fromOriginal: aMocoWrappedElement onEngine: anEngine [
	((aMocoWrappedElement innerElement source element isKindOf: MocoOntoUmlQuality) or: [ aMocoWrappedElement innerElement target element isKindOf: MocoOntoUmlQuality ])
		ifTrue: [
			aMocoUmlAssociation source frozen: true.
			aMocoUmlAssociation target frozen: true
		].
	
	(aMocoWrappedElement innerElement source element isKindOf: MocoOntoUmlMode) ifTrue: [ aMocoUmlAssociation target frozen: true ].
	(aMocoWrappedElement innerElement target element isKindOf: MocoOntoUmlMode) ifTrue: [ aMocoUmlAssociation source frozen: true ].
]

{ #category : #accessing }
MocoOntoUmlCharacterizationAssociationTransformationRule >> priority [
	^ 45
]
