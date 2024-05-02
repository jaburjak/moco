Class {
	#name : #MocoO2URulePriorityTest,
	#superclass : #MocoTransformationRuleTestCase,
	#traits : 'MocoTransformationRulePriorityTestTrait',
	#classTraits : 'MocoTransformationRulePriorityTestTrait classTrait',
	#category : #'Moco-O2U-Tests-Rule'
}

{ #category : #tests }
MocoO2URulePriorityTest >> testAssociationStereotypePriority [
	self assertRule: MocoOntoUmlAssociationTransformationRule
		isAfter: { MocoOntoUmlCharacterizationAssociationTransformationRule.
		           MocoOntoUmlMaterialAssociationTransformationRule.
		           MocoOntoUmlMediationAssociationTransformationRule.
		           MocoOntoUmlPartWholeAssociationTransformationRule.
		           MocoOntoUmlContainmentAssociationTransformationRule }.
	
	self assertRule: MocoOntoUmlPartWholeAssociationTransformationRule
		isAfter: { MocoOntoUmlContainmentAssociationTransformationRule }
]

{ #category : #tests }
MocoO2URulePriorityTest >> testClassPriority [
	self assertRule: MocoOntoUmlClassTransformationRule
		isBefore: { MocoOntoUmlAssociationTransformationRule.
		            MocoOntoUmlEnumerationTransformationRule.
		            MocoOntoUmlGeneralizationTransformationRule.
		            MocoOntoUmlGeneralizationSetTransformationRule.
		            MocoOntoUmlRelatorOptimizationTransformationRule.
		            MocoOntoUmlRoleOptimizationTransformationRule }
]

{ #category : #tests }
MocoO2URulePriorityTest >> testClassStereotypePriority [
	self assertRule: MocoOntoUmlClassTransformationRule
		isAfter: { MocoOntoUmlCategoryTransformationRule.
		           MocoOntoUmlCollectiveTransformationRule.
		           MocoOntoUmlKindTransformationRule.
		           MocoOntoUmlMixinTransformationRule.
		           MocoOntoUmlPhaseMixinTransformationRule.
		           MocoOntoUmlRoleMixinTransformationRule.
		           MocoOntoUmlModeTransformationRule.
		           MocoOntoUmlPhaseTransformationRule.
		           MocoOntoUmlQualityTransformationRule.
		           MocoOntoUmlQuantityTransformationRule.
		           MocoOntoUmlRelatorTransformationRule.
		           MocoOntoUmlRoleTransformationRule.
		           MocoOntoUmlSubKindTransformationRule }
]

{ #category : #tests }
MocoO2URulePriorityTest >> testGeneralizationPriority [
	self assertRule: MocoOntoUmlGeneralizationTransformationRule
		isBefore: { MocoOntoUmlGeneralizationSetTransformationRule }
]

{ #category : #tests }
MocoO2URulePriorityTest >> testOptimizationPriority [
	| after |
	after := { MocoOntoUmlClassTransformationRule.
		        MocoOntoUmlAssociationTransformationRule.
		        MocoOntoUmlGeneralizationTransformationRule.
		        MocoOntoUmlGeneralizationSetTransformationRule }.

	self assertRule: MocoOntoUmlRelatorOptimizationTransformationRule isAfter: after;
		assertRule: MocoOntoUmlRoleOptimizationTransformationRule isAfter: after
]
