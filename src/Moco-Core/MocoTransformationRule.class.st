"
Represents a Transformation Rule.
"
Class {
	#name : #MocoTransformationRule,
	#superclass : #Object,
	#instVars : [
		'engine'
	],
	#category : #'Moco-Core-Rule'
}

{ #category : #'instance creation' }
MocoTransformationRule class >> new [
	self error: 'MocoTransformationRule must be instanciated by sending newWithEngine:'
	
	
]

{ #category : #'instance creation' }
MocoTransformationRule class >> newWithEngine: anEngine [
	| inst |
	
	self className = 'MocoTransformationRule' ifTrue: [ self error: 'MocoTransformationRule should not be instanciated, send newWithEngine: to concrete implementors instead.' ].
	
	inst := self basicNew.
	
	inst engine: anEngine.
	
	^ inst
]

{ #category : #'private - accessing' }
MocoTransformationRule >> engine [
	^ engine
]

{ #category : #'private - accessing' }
MocoTransformationRule >> engine: anEngine [
	engine := anEngine
]

{ #category : #transforming }
MocoTransformationRule >> execute [
	"Executes this transformation rule."

	^ self shouldBeImplemented
]

{ #category : #accessing }
MocoTransformationRule >> priority [
	^ 0
]
