Class {
	#name : #MocoD2STestSuite,
	#superclass : #TestSuite,
	#category : #'Moco-D2S-Tests-Suite'
}

{ #category : #initialization }
MocoD2STestSuite >> initialize [
	| suites |

	super initialize.
	
	suites := { MocoRdbTableTransformationRuleTest.
	            MocoRdbForeignKeyTransformationRuleTest.
	            MocoRdbOclEnumerationTransformationRuleTest.
	            MocoRdbOclExclusiveAssociationTransformationRuleTest.
	            MocoRdbOclGeneralizationSetTransformationRuleTest.
	            MocoRdbOclMandatoryMultiplicityTransformationRuleTest.
	            MocoRdbOclSpecialMultiplicityTransformationRuleTest.
	            MocoRdbOclImmutableAssociationDeleteTransformationRuleTest.
	            MocoRdbOclImmutableColumnTransformationRuleTest.
	            MocoD2SRulePriorityTest }.
	
	suites do: [ :each | self addTest: each suite ]
]
