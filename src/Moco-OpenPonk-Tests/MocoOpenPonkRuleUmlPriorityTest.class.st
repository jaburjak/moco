Class {
	#name : #MocoOpenPonkRuleUmlPriorityTest,
	#superclass : #MocoTransformationRuleTestCase,
	#traits : 'MocoTransformationRulePriorityTestTrait',
	#classTraits : 'MocoTransformationRulePriorityTestTrait classTrait',
	#category : #'Moco-OpenPonk-Tests-Rule-Uml'
}

{ #category : #tests }
MocoOpenPonkRuleUmlPriorityTest >> testClassPriority [
	self assertRule: MocoOpenPonkUmlClassTransformationRule
		isBefore: { MocoOpenPonkUmlAssociationTransformationRule.
		            MocoOpenPonkUmlGeneralizationTransformationRule.
		            MocoOpenPonkUmlOclTransformationRule }
]

{ #category : #tests }
MocoOpenPonkRuleUmlPriorityTest >> testEnumerationPriority [
	self assertRule: MocoOpenPonkUmlEnumerationTransformationRule
		isBefore: { MocoOpenPonkUmlAssociationTransformationRule }
]

{ #category : #tests }
MocoOpenPonkRuleUmlPriorityTest >> testGeneralizationPriority [
	self assertRule: MocoOpenPonkUmlGeneralizationTransformationRule
		isBefore: { MocoOpenPonkUmlGeneralizationSetTransformationRule }
]
