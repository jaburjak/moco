Class {
	#name : 'MocoD2SOracleRulePriorityTest',
	#superclass : 'MocoTransformationRuleTestCase',
	#traits : 'MocoTransformationRulePriorityTestTrait',
	#classTraits : 'MocoTransformationRulePriorityTestTrait classTrait',
	#category : 'Moco-D2SOracle-Tests-Rule',
	#package : 'Moco-D2SOracle-Tests',
	#tag : 'Rule'
}

{ #category : 'tests' }
MocoD2SOracleRulePriorityTest >> testForeignKeyPriority [
	self assertRule: MocoRdbOracleForeignKeyTransformationRule
		isAfter: { MocoRdbOracleTableTransformationRule }
]

{ #category : 'tests' }
MocoD2SOracleRulePriorityTest >> testTablePriority [
	self assertRule: MocoRdbOracleTableTransformationRule
		isBefore: { MocoRdbOracleForeignKeyTransformationRule.
		            MocoRdbOracleOclEnumerationTransformationRule.
		            MocoRdbOracleOclExclusiveAssociationTransformationRule.
		            MocoRdbOracleOclGeneralizationSetTransformationRule.
		            MocoRdbOracleOclImmutableAssociationDeleteTransformationRule.
		            MocoRdbOracleOclImmutableColumnTransformationRule.
		            MocoRdbOracleOclMandatoryMultiplicityTransformationRule.
		            MocoRdbOracleOclSpecialMultiplicityTransformationRule }
]
