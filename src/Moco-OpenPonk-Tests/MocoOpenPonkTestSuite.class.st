Class {
	#name : #MocoOpenPonkTestSuite,
	#superclass : #TestSuite,
	#category : #'Moco-OpenPonk-Tests-Suite'
}

{ #category : #initialization }
MocoOpenPonkTestSuite >> initialize [
	| suites |

	super initialize.
	
	suites := { MocoOpenPonkOntoUmlClassTransformationRuleTest.
	            MocoOpenPonkOntoUmlKindTransformationRuleTest.
	            MocoOpenPonkOntoUmlSubKindTransformationRuleTest.
	            MocoOpenPonkOntoUmlRelatorTransformationRuleTest.
	            MocoOpenPonkOntoUmlCollectiveTransformationRuleTest.
	            MocoOpenPonkOntoUmlQualityTransformationRuleTest.
	            MocoOpenPonkOntoUmlRoleTransformationRuleTest.
	            MocoOpenPonkOntoUmlPhaseTransformationRuleTest.
	            MocoOpenPonkOntoUmlRoleMixinTransformationRuleTest.
	            MocoOpenPonkOntoUmlPhaseMixinTransformationRuleTest.
	            MocoOpenPonkOntoUmlMixinTransformationRuleTest.
	            MocoOpenPonkOntoUmlCategoryTransformationRuleTest.
	            MocoOpenPonkOntoUmlQualityTransformationRuleTest.
	            MocoOpenPonkOntoUmlModeTransformationRuleTest.
	            MocoOpenPonkOntoUmlAssociationTransformationRuleTest.
	            MocoOpenPonkOntoUmlCharacterizationAssociationTransformationRuleTest.
	            MocoOpenPonkOntoUmlContainmentAssociationTransformationRuleTest.
	            MocoOpenPonkOntoUmlFormalAssociationTransformationRuleTest.
	            MocoOpenPonkOntoUmlMaterialAssociationTransformationRuleTest.
	            MocoOpenPonkOntoUmlMediationAssociationTransformationRuleTest.
	            MocoOpenPonkOntoUmlComponentOfAssociationTransformationRuleTest.
	            MocoOpenPonkOntoUmlMemberOfAssociationTransformationRuleTest.
	            MocoOpenPonkOntoUmlSubCollectionOfAssociationTransformationRuleTest.
	            MocoOpenPonkOntoUmlSubQuantityOfAssociationTransformationRuleTest.
	            MocoOpenPonkOntoUmlEnumerationTransformationRuleTest.
	            MocoOpenPonkOntoUmlGeneralizationTransformationRuleTest.
	            MocoOpenPonkOntoUmlGeneralizationSetTransformationRuleTest.
	            MocoOpenPonkUmlClassTransformationRuleTest.
	            MocoOpenPonkUmlAssociationTransformationRuleTest.
	            MocoOpenPonkUmlEnumerationTransformationRuleTest.
	            MocoOpenPonkUmlGeneralizationTransformationRuleTest.
	            MocoOpenPonkUmlGeneralizationSetTransformationRuleTest.
	            MocoOpenPonkUmlOclTransformationRuleTest.
	            MocoOpenPonkRdbTableTransformationRuleTest.
	            MocoOpenPonkRdbForeignKeyTransformationRuleTest.
	            MocoOpenPonkRdbOclTransformationRuleTest }.
	
	suites do: [ :each | self addTest: each suite ]
]
