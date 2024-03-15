"
Base class that represents an OCL precondition.
"
Class {
	#name : #MocoOclPreCondition,
	#superclass : #MocoOclCondition,
	#category : #'Moco-Ocl-Model'
}

{ #category : #accessing }
MocoOclPreCondition class >> type [
	^ #pre
]
