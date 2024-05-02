Class {
	#name : #MocoOpenPonkRulePriorityTest,
	#superclass : #MocoTransformationRuleTestCase,
	#traits : 'MocoTransformationRulePriorityTestTrait',
	#classTraits : 'MocoTransformationRulePriorityTestTrait classTrait',
	#category : #'Moco-OpenPonk-Tests-Rule'
}

{ #category : #tests }
MocoOpenPonkRulePriorityTest >> testClassPriority [
	self assertRule: MocoOpenPonkOntoUmlClassTransformationRule
		isBefore: { MocoOpenPonkOntoUmlAssociationTransformationRule.
		            MocoOpenPonkOntoUmlEnumerationTransformationRule.
		            MocoOpenPonkOntoUmlGeneralizationTransformationRule.
		            MocoOpenPonkOntoUmlGeneralizationSetTransformationRule }
]

{ #category : #tests }
MocoOpenPonkRulePriorityTest >> testGeneralizationPriority [
	self assertRule: MocoOpenPonkOntoUmlGeneralizationTransformationRule
		isBefore: { MocoOpenPonkOntoUmlGeneralizationSetTransformationRule }
]
