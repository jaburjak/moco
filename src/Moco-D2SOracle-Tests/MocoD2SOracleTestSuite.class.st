Class {
	#name : 'MocoD2SOracleTestSuite',
	#superclass : 'TestSuite',
	#category : 'Moco-D2SOracle-Tests-Suite',
	#package : 'Moco-D2SOracle-Tests',
	#tag : 'Suite'
}

{ #category : 'initialization' }
MocoD2SOracleTestSuite >> initialize [
	| suites |

	super initialize.
	
	suites := { MocoRdbOracleTableTransformationRuleTest.
	            MocoRdbOracleForeignKeyTransformationRuleTest.
	            MocoRdbOracleOclEnumerationTransformationRuleTest.
	            MocoRdbOracleOclExclusiveAssociationTransformationRuleTest.
	            MocoRdbOracleOclGeneralizationSetTransformationRuleTest.
	            MocoRdbOracleOclMandatoryMultiplicityTransformationRuleTest.
	            MocoRdbOracleOclSpecialMultiplicityTransformationRuleTest.
	            MocoRdbOracleOclImmutableAssociationDeleteTransformationRuleTest.
	            MocoRdbOracleOclImmutableColumnTransformationRuleTest.
	            MocoD2SOracleRulePriorityTest }.
	
	suites do: [ :each | self addTest: each suite ]
]
