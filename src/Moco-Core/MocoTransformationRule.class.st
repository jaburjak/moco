"
Represents a Transformation Rule.
"
Class {
	#name : #MocoTransformationRule,
	#superclass : #Object,
	#category : #'Moco-Core-Rule'
}

{ #category : #'instance creation' }
MocoTransformationRule class >> new [
	self error: 'TransformationRule should not be instanciated, send new to concrete implementors instead.'
]

{ #category : #accessing }
MocoTransformationRule >> executeOn: anEngine [
	"Executes this transformation rule on the given TransformationEngine."

	^ self shouldBeImplemented
]

{ #category : #accessing }
MocoTransformationRule >> priority [
	^ 0
]
