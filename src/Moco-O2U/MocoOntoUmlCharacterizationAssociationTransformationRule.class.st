"
Transforms OntoUML Characterization relationship into a UML association.
"
Class {
	#name : #MocoOntoUmlCharacterizationAssociationTransformationRule,
	#superclass : #MocoOntoUmlAssociationTransformationRule,
	#category : #'Moco-O2U-Rule'
}

{ #category : #'private - accessing' }
MocoOntoUmlCharacterizationAssociationTransformationRule class >> modelSelector [
	^ MocoOntoUmlCharacterizationAssociation
]

{ #category : #'private - processing' }
MocoOntoUmlCharacterizationAssociationTransformationRule >> modifyAssociation: aMocoUmlAssociation fromOriginal: aMocoOntoUmlAssociation [
	"Sets associations sides as immutable."
	
	((aMocoOntoUmlAssociation source element isKindOf: MocoOntoUmlQuality) or: [ aMocoOntoUmlAssociation target element isKindOf: MocoOntoUmlQuality ])
		ifTrue: [
			aMocoUmlAssociation source frozen: true.
			aMocoUmlAssociation target frozen: true
		].
	
	(aMocoOntoUmlAssociation source element isKindOf: MocoOntoUmlMode) ifTrue: [ aMocoUmlAssociation target frozen: true ].
	(aMocoOntoUmlAssociation target element isKindOf: MocoOntoUmlMode) ifTrue: [ aMocoUmlAssociation source frozen: true ].
]

{ #category : #accessing }
MocoOntoUmlCharacterizationAssociationTransformationRule >> priority [
	^ 45
]
