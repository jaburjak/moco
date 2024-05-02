Class {
	#name : #MocoOpenPonkRuleRdbPriorityTest,
	#superclass : #MocoTransformationRuleTestCase,
	#traits : 'MocoTransformationRulePriorityTestTrait',
	#classTraits : 'MocoTransformationRulePriorityTestTrait classTrait',
	#category : #'Moco-OpenPonk-Tests-Rule-Rdb'
}

{ #category : #tests }
MocoOpenPonkRuleRdbPriorityTest >> testTablePriority [
	self assertRule: MocoOpenPonkRdbTableTransformationRule
		isBefore: { MocoOpenPonkRdbForeignKeyTransformationRule.
		            MocoOpenPonkRdbOclTransformationRule } 
]
