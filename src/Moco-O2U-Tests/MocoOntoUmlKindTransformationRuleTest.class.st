Class {
	#name : #MocoOntoUmlKindTransformationRuleTest,
	#superclass : #MocoOntoUmlClassTransformationRuleTest,
	#category : #'Moco-O2U-Tests-Rule'
}

{ #category : #'private - processing' }
MocoOntoUmlKindTransformationRuleTest >> execute [
	^ self execute: MocoOntoUmlKindTransformationRule
]

{ #category : #tests }
MocoOntoUmlKindTransformationRuleTest >> testKind [
	| ou |
	ou := MocoOntoUmlKind new.
	
	engine input addElement: ou.
	
	self execute.
	
	self assert: (engine output elements first isKindOf: MocoUmlClass)
]
