Class {
	#name : #MocoOpenPonkOntoUmlMaterialAssociationTransformationRuleTest,
	#superclass : #MocoOpenPonkOntoUmlAssociationTransformationRuleTest,
	#category : #'Moco-OpenPonk-Tests-Rule'
}

{ #category : #'private - processing' }
MocoOpenPonkOntoUmlMaterialAssociationTransformationRuleTest >> execute [
	^ self execute: MocoOpenPonkOntoUmlMaterialAssociationTransformationRule
]

{ #category : #tests }
MocoOpenPonkOntoUmlMaterialAssociationTransformationRuleTest >> testMaterial [
	| op |
	op := OPUMLAssociation new applyStereotype: (OntoUMLMaterial new); yourself.
	op memberEnds add: (OPUMLProperty new type: (source first); yourself).
	op memberEnds add: (OPUMLProperty new type: (target first); yourself).
	
	engine input addElement: op.
	
	self execute.
	
	self assert: (engine output elements anySatisfy: [ :each | each isKindOf: MocoOntoUmlMaterialAssociation ])
]
