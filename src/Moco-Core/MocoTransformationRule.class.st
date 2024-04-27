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
	self error: 'MocoTransformationRule must be instantiated by sending newWithEngine:'
	
	
]

{ #category : #'instance creation' }
MocoTransformationRule class >> newWithEngine: anEngine [
	| inst |
	
	self className = 'MocoTransformationRule' ifTrue: [ ^ self subclassResponsibility ].
	
	inst := self basicNew.
	
	inst engine: anEngine.
	
	inst initialize.
	
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
