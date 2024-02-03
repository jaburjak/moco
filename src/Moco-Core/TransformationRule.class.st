"
Represents a Transformation Rule.
"
Class {
	#name : #TransformationRule,
	#superclass : #Object,
	#category : #'Moco-Core-Rule'
}

{ #category : #'instance creation' }
TransformationRule class >> new [
	self error: 'TransformationRule should not be instanciated, send new to concrete implementors instead.'
]

{ #category : #accessing }
TransformationRule >> executeOn: anEngine [
	"Executes this transformation rule on the given TransformationEngine."

	^ self shouldBeImplemented
]

{ #category : #accessing }
TransformationRule >> priority [
	^ self shouldBeImplemented
]
