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

{ #category : #accessing }
MocoOntoUmlCharacterizationAssociationTransformationRule >> priority [
	^ 45
]

{ #category : #'private - transforming' }
MocoOntoUmlCharacterizationAssociationTransformationRule >> toUmlAssociation: aMocoOntoUmlAssociation [
	"Sets associations sides as immutable."
	
	| uml |
	uml := super toUmlAssociation: aMocoOntoUmlAssociation.
	
	((aMocoOntoUmlAssociation source element isKindOf: MocoOntoUmlQuality) or: [ aMocoOntoUmlAssociation target element isKindOf: MocoOntoUmlQuality ])
		ifTrue: [
			uml source frozen: true.
			uml target frozen: true
		].
	
	(aMocoOntoUmlAssociation source element isKindOf: MocoOntoUmlMode) ifTrue: [ uml target frozen: true ].
	(aMocoOntoUmlAssociation target element isKindOf: MocoOntoUmlMode) ifTrue: [ uml source frozen: true ].
	
	^ uml
]
