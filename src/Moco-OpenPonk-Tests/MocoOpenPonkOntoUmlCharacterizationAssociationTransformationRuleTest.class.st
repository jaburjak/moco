Class {
	#name : #MocoOpenPonkOntoUmlCharacterizationAssociationTransformationRuleTest,
	#superclass : #MocoOpenPonkOntoUmlAssociationTransformationRuleTest,
	#category : #'Moco-OpenPonk-Tests-Rule'
}

{ #category : #'private - processing' }
MocoOpenPonkOntoUmlCharacterizationAssociationTransformationRuleTest >> execute [
	^ self execute: MocoOpenPonkOntoUmlCharacterizationAssociationTransformationRule
]

{ #category : #tests }
MocoOpenPonkOntoUmlCharacterizationAssociationTransformationRuleTest >> testCharacterization [
	| op |
	op := OPUMLAssociation new applyStereotype: (OntoUMLCharacterization new); yourself.
	op memberEnds add: (OPUMLProperty new type: (source first); yourself).
	op memberEnds add: (OPUMLProperty new type: (target first); yourself).
	
	engine input addElement: op.
	
	self execute.
	
	self assert: (engine output elements anySatisfy: [ :each | each isKindOf: MocoOntoUmlCharacterizationAssociation ])
]

{ #category : #tests }
MocoOpenPonkOntoUmlCharacterizationAssociationTransformationRuleTest >> testModeDirection [
	| mode op m |
	mode := { OPUMLClass new applyStereotype: (OntoUMLMode new); yourself. MocoOntoUmlMode new }.

	engine input addElement: (mode first).
	engine addOutputElement: (mode second) withSource: (mode first).

	op := OPUMLAssociation new applyStereotype: (OntoUMLCharacterization new); yourself.
	op memberEnds add: (OPUMLProperty new type: (mode first); yourself).
	op memberEnds add: (OPUMLProperty new type: (target first); yourself).
	
	engine input addElement: op.
	
	self execute.
	
	m := engine output elements detect: [ :each | each isKindOf: MocoOntoUmlAssociation ].
	
	self assert: (m source element) identicalTo: (target second);
		assert: (m target element) identicalTo: (mode second) 
]

{ #category : #tests }
MocoOpenPonkOntoUmlCharacterizationAssociationTransformationRuleTest >> testQualityDirection [
	| quality op m |
	quality := { OPUMLClass new applyStereotype: (OntoUMLQuality new); yourself. MocoOntoUmlQuality new }.

	engine input addElement: (quality first).
	engine addOutputElement: (quality second) withSource: (quality first).

	op := OPUMLAssociation new applyStereotype: (OntoUMLCharacterization new); yourself.
	op memberEnds add: (OPUMLProperty new type: (quality first); yourself).
	op memberEnds add: (OPUMLProperty new type: (target first); yourself).
	
	engine input addElement: op.
	
	self execute.
	
	m := engine output elements detect: [ :each | each isKindOf: MocoOntoUmlAssociation ].
	
	self assert: (m source element) identicalTo: (target second);
		assert: (m target element) identicalTo: (quality second) 
]
