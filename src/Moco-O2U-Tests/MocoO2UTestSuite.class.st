Class {
	#name : #MocoO2UTestSuite,
	#superclass : #TestSuite,
	#category : #'Moco-O2U-Tests-Suite'
}

{ #category : #initialization }
MocoO2UTestSuite >> initialize [
	| suites |

	super initialize.
	
	suites := { MocoOntoUmlClassTransformationRuleTest.
	            MocoOntoUmlKindTransformationRuleTest.
	            MocoOntoUmlSubKindTransformationRuleTest.
	            MocoOntoUmlRelatorTransformationRuleTest.
	            MocoOntoUmlCollectiveTransformationRuleTest.
	            MocoOntoUmlQuantityTransformationRuleTest.
	            MocoOntoUmlRoleTransformationRuleTest.
	            MocoOntoUmlPhaseTransformationRuleTest.
	            MocoOntoUmlRoleMixinTransformationRuleTest.
	            MocoOntoUmlPhaseMixinTransformationRuleTest.
	            MocoOntoUmlMixinTransformationRuleTest.
	            MocoOntoUmlCategoryTransformationRuleTest.
	            MocoOntoUmlQualityTransformationRuleTest.
	            MocoOntoUmlModeTransformationRuleTest.
	            MocoOntoUmlAssociationTransformationRuleTest.
	            MocoOntoUmlCharacterizationAssociationTransformationRuleTest.
	            MocoOntoUmlMaterialAssociationTransformationRuleTest.
	            MocoOntoUmlMediationAssociationTransformationRuleTest.
	            MocoOntoUmlPartWholeAssociationTransformationRuleTest.
	            MocoOntoUmlContainmentAssociationTransformationRuleTest.
	            MocoOntoUmlEnumerationTransformationRuleTest.
	            MocoOntoUmlGeneralizationTransformationRuleTest.
	            MocoOntoUmlGeneralizationSetTransformationRuleTest.
	            MocoOntoUmlRelatorOptimizationTransformationRuleTest.
	            MocoOntoUmlRoleOptimizationTransformationRuleTest }.
	
	suites do: [ :each | self addTest: each suite ]
]
