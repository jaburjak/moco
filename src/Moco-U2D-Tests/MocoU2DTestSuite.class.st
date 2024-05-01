Class {
	#name : #MocoU2DTestSuite,
	#superclass : #TestSuite,
	#category : #'Moco-U2D-Tests-Suite'
}

{ #category : #initialization }
MocoU2DTestSuite >> initialize [
	| suites |

	super initialize.
	
	suites := { MocoUmlCopyTransformationRuleTest.
	            MocoUmlCopyFixReferencesTransformationRuleTest.
	            MocoUmlEnumerationTransformationRuleTest.
	            MocoUmlManyToManyAssociationTransformationRuleTest.
	            MocoUmlNonNativeRdbTypeTransformationRuleTest.
	            MocoUmlMultiValueAttributeTransformationRuleTest }.
	
	suites do: [ :each | self addTest: each suite ]
]
