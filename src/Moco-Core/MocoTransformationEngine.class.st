"
Transforms one model to another according to specified rules.
"
Class {
	#name : #MocoTransformationEngine,
	#superclass : #Object,
	#instVars : [
		'rules',
		'inModel',
		'outModel'
	],
	#category : #'Moco-Core-Engine'
}

{ #category : #'private - transforming' }
MocoTransformationEngine >> applyRule: aRule [
	"Executes the given transformation rule repeatedly until the output model no longer changes."

	[
		outModel meta didChange: false.
		aRule executeOn: self.
		outModel meta didChange.
	] whileTrue.
]

{ #category : #'private - transforming' }
MocoTransformationEngine >> applyRules [
	"Applies transformation rules."

	rules do: [ :rule | self applyRule: rule ]
]

{ #category : #accessing }
MocoTransformationEngine >> inModel [
	^ inModel
]

{ #category : #accessing }
MocoTransformationEngine >> inModel: aWrappedModel [
	inModel := aWrappedModel
]

{ #category : #initialization }
MocoTransformationEngine >> initialize [
	super initialize.
	
	rules := SortedCollection sortBlock: [ :a :b | (a priority) > (b priority) ].
]

{ #category : #accessing }
MocoTransformationEngine >> outModel [
	^ outModel
]

{ #category : #accessing }
MocoTransformationEngine >> outModel: aWrappedModel [
	outModel := aWrappedModel
]

{ #category : #accessing }
MocoTransformationEngine >> rules [
	^ rules
]

{ #category : #transforming }
MocoTransformationEngine >> transform [
	"Transforms the model using transformation rules."

	[
		outModel meta didChange: false.
		self applyRules.
		outModel meta didChange.
	] whileTrue.

	self verifyTransformSucceeded.
]

{ #category : #'as yet unclassified' }
MocoTransformationEngine >> verifyTransformSucceeded [
	"Throws an error in case the input model contains non-exhausted elements."

	(inModel elements anySatisfy: [ :e | e meta exhausted not ]) ifTrue: [ self error: 'Could not transform all elements in the model.' ]
]
