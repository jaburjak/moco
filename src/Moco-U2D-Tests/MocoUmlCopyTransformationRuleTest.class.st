Class {
	#name : #MocoUmlCopyTransformationRuleTest,
	#superclass : #MocoTransformationRuleTestCase,
	#category : #'Moco-U2D-Tests-Rule-Preprocess'
}

{ #category : #'private - processing' }
MocoUmlCopyTransformationRuleTest >> execute [
	^ self execute: MocoUmlCopyTransformationRule
]

{ #category : #tests }
MocoUmlCopyTransformationRuleTest >> testCopy [
	| element |
	element := 'TestElement'.
	
	engine input addElement: element.
	
	self execute.
	
	self assert: (engine output elements size) equals: 1;
		assert: (engine output elements first) equals: element;
		assert: ((engine output elements first) == element second) equals: false
]
