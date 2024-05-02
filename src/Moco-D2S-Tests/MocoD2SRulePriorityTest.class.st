Class {
	#name : #MocoD2SRulePriorityTest,
	#superclass : #MocoTransformationRuleTestCase,
	#traits : 'MocoTransformationRulePriorityTestTrait',
	#classTraits : 'MocoTransformationRulePriorityTestTrait classTrait',
	#category : #'Moco-D2S-Tests-Rule'
}

{ #category : #tests }
MocoD2SRulePriorityTest >> testForeignKeyPriority [
	self assertRule: MocoRdbForeignKeyTransformationRule
		isAfter: { MocoRdbTableTransformationRule }
]

{ #category : #tests }
MocoD2SRulePriorityTest >> testTablePriority [
	self assertRule: MocoRdbTableTransformationRule
		isBefore: { MocoRdbForeignKeyTransformationRule.
		            MocoRdbOclEnumerationTransformationRule.
		            MocoRdbOclExclusiveAssociationTransformationRule.
		            MocoRdbOclGeneralizationSetTransformationRule.
		            MocoRdbOclImmutableAssociationDeleteTransformationRule.
		            MocoRdbOclImmutableColumnTransformationRule.
		            MocoRdbOclMandatoryMultiplicityTransformationRule.
		            MocoRdbOclSpecialMultiplicityTransformationRule }
]
