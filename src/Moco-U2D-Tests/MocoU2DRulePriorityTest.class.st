Class {
	#name : #MocoU2DRulePriorityTest,
	#superclass : #MocoTransformationRuleTestCase,
	#traits : 'MocoTransformationRulePriorityTestTrait',
	#classTraits : 'MocoTransformationRulePriorityTestTrait classTrait',
	#category : #'Moco-U2D-Tests-Rule'
}

{ #category : #tests }
MocoU2DRulePriorityTest >> testClassRulePriority [
	self assertRule: MocoUmlClassTransformationRule
		isBefore: { MocoUmlAssociationTransformationRule.
		            MocoUmlGeneralizationTransformationRule.
		            MocoUmlGeneralizationSetTransformationRule.
		            MocoUmlOclEnumerationConstraintTransformationRule.
		            MocoUmlOclExclusiveAssociationConditionTransformationRule }
]

{ #category : #tests }
MocoU2DRulePriorityTest >> testGeneralizationRulePriority [
	self assertRule: MocoUmlGeneralizationTransformationRule
		isBefore: { MocoUmlGeneralizationSetTransformationRule }
]

{ #category : #tests }
MocoU2DRulePriorityTest >> testMediatingClassRulePriority [
	self assertRule: MocoUmlAssociationTransformationRule
		isBefore: { MocoUmlMediatingClassOptimizationTransformationRule }
]
