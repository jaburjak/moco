Class {
	#name : #MocoOntoUmlSubKindTransformationRuleTest,
	#superclass : #MocoOntoUmlClassTransformationRuleTest,
	#category : #'Moco-O2U-Tests-Rule'
}

{ #category : #'private - processing' }
MocoOntoUmlSubKindTransformationRuleTest >> execute [
	^ self execute: MocoOntoUmlSubKindTransformationRule
]

{ #category : #tests }
MocoOntoUmlSubKindTransformationRuleTest >> testSubKind [
	| ou |
	ou := MocoOntoUmlSubKind new.
	
	engine input addElement: ou.
	
	self execute.
	
	self assert: (engine output elements first isKindOf: MocoUmlClass)
]
