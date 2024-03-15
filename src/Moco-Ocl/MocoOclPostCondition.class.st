"
Base class that represents an OCL postcondition.
"
Class {
	#name : #MocoOclPostCondition,
	#superclass : #MocoOclCondition,
	#category : #'Moco-Ocl-Model'
}

{ #category : #accessing }
MocoOclPostCondition class >> type [
	^ #post
]
