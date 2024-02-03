"
Transforms one model to another according to specified rules.
"
Class {
	#name : #TransformationEngine,
	#superclass : #Object,
	#instVars : [
		'rules',
		'inModel',
		'outModel'
	],
	#category : #'Moco-Core-Engine'
}

{ #category : #'private - transforming' }
TransformationEngine >> applyRule: aRule [
	"Executes the given transformation rule repeatedly until the output model no longer changes."

	[
		aRule executeOn: self.
		outModel meta didChange.
	] whileTrue.
]

{ #category : #'private - transforming' }
TransformationEngine >> applyRules [
	"Applies transformation rules."

	rules do: [ :rule | self applyRule: rule ]
]

{ #category : #accessing }
TransformationEngine >> inModel [
	^ inModel
]

{ #category : #accessing }
TransformationEngine >> inModel: aWrappedModel [
	inModel := aWrappedModel
]

{ #category : #initialization }
TransformationEngine >> initialize [
	super initialize.
	
	rules := SortedCollection sortBlock: [ :a :b | (a priority) > (b priority) ].
]

{ #category : #accessing }
TransformationEngine >> outModel [
	^ outModel
]

{ #category : #accessing }
TransformationEngine >> outModel: aWrappedModel [
	outModel := aWrappedModel
]

{ #category : #accessing }
TransformationEngine >> rules [
	^ rules
]

{ #category : #transforming }
TransformationEngine >> transform [
	"Transforms the model using transformation rules."

	[
		self applyRules.
		outModel meta didChange.
	] whileTrue.

	self verifyTransformSucceeded.
]

{ #category : #'as yet unclassified' }
TransformationEngine >> verifyTransformSucceeded [
	"Throws an error in case the input model contains non-exhausted elements."

	(inModel elements anySatisfy: [ :e | e meta exhausted not ]) ifTrue: [ self error: 'Could not transform all elements in the model.' ]
]
