Class {
	#name : #MocoU2DRulePreprocessPriorityTest,
	#superclass : #MocoTransformationRuleTestCase,
	#traits : 'MocoTransformationRulePriorityTestTrait',
	#classTraits : 'MocoTransformationRulePriorityTestTrait classTrait',
	#category : #'Moco-U2D-Tests-Rule-Preprocess'
}

{ #category : #tests }
MocoU2DRulePreprocessPriorityTest >> testCopyRulePriority [
	self assertRule: MocoUmlCopyTransformationRule
		isBefore: { MocoUmlCopyFixReferencesTransformationRule.
		            MocoUmlEnumerationTransformationRule.
		            MocoUmlNonNativeRdbTypeTransformationRule.
		            MocoUmlMultiValueAttributeTransformationRule.
		            MocoUmlManyToManyAssociationTransformationRule }
]

{ #category : #tests }
MocoU2DRulePreprocessPriorityTest >> testFixRulePriority [
	self assertRule: MocoUmlCopyFixReferencesTransformationRule
		isBefore: { MocoUmlEnumerationTransformationRule.
		            MocoUmlNonNativeRdbTypeTransformationRule.
		            MocoUmlMultiValueAttributeTransformationRule.
		            MocoUmlManyToManyAssociationTransformationRule }
]

{ #category : #tests }
MocoU2DRulePreprocessPriorityTest >> testOrder [
	self assertRuleOrder: { MocoUmlEnumerationTransformationRule.
	                        MocoUmlNonNativeRdbTypeTransformationRule.
	                        MocoUmlMultiValueAttributeTransformationRule.
	                        MocoUmlManyToManyAssociationTransformationRule }
]
