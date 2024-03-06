"
Transforms OpenPonk’s Characterization OntoUML association into Moco’s counterpart.
"
Class {
	#name : #MocoOpenPonkOntoUmlCharacterizationAssociationTransformationRule,
	#superclass : #MocoOpenPonkOntoUmlSpecializedAssociationTransformationRule,
	#category : #'Moco-OpenPonk-Rule'
}

{ #category : #'private - accessing' }
MocoOpenPonkOntoUmlCharacterizationAssociationTransformationRule class >> modelClass [
	^ MocoOntoUmlCharacterizationAssociation
]

{ #category : #'private - accessing' }
MocoOpenPonkOntoUmlCharacterizationAssociationTransformationRule class >> stereotypeSelector [
	^ OntoUMLCharacterization
]

{ #category : #'private - processing' }
MocoOpenPonkOntoUmlCharacterizationAssociationTransformationRule >> modifyAssociation: aMocoOntoUmlCharacterizationAssociation [
	((aMocoOntoUmlCharacterizationAssociation source element isKindOf: MocoOntoUmlQuality) or: [ aMocoOntoUmlCharacterizationAssociation source element isKindOf: MocoOntoUmlMode ])
		ifTrue: [
			| tmp |
			tmp := aMocoOntoUmlCharacterizationAssociation source.
			
			aMocoOntoUmlCharacterizationAssociation source: (aMocoOntoUmlCharacterizationAssociation target);
				target: tmp
		]
]
