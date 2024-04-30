Class {
	#name : #MocoTransformationRuleTestCase,
	#superclass : #TestCase,
	#instVars : [
		'engine'
	],
	#category : #'Moco-Core-Tests-Rule'
}

{ #category : #'private - processing' }
MocoTransformationRuleTestCase >> execute: aClass [
	"Executes the given transformation rule."
	
	(engine rules noneSatisfy: [ :each | (each class name) = (aClass name) ]) ifTrue: [
		| rule |
		rule := aClass newWithEngine: engine.
		
		engine rules add: rule
	].

	engine transform
	
	
]

{ #category : #running }
MocoTransformationRuleTestCase >> setUp [
	super setUp.

	engine := MocoTestTransformationEngine new
]
