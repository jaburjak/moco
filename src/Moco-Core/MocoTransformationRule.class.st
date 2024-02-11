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
	| inst |

	self className = 'MocoTransformationRule' ifTrue: [ self error: 'MocoTransformationRule should not be instanciated, send new to concrete implementors instead.' ].
	
	inst := self basicNew.
	inst initialize.
	
	^ inst
	
	
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
