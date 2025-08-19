"
Base class that represents an OCL precondition.
"
Class {
	#name : 'MocoOclPreCondition',
	#superclass : 'MocoOclCondition',
	#category : 'Moco-Ocl-Model',
	#package : 'Moco-Ocl',
	#tag : 'Model'
}

{ #category : 'accessing' }
MocoOclPreCondition class >> type [
	^ #pre
]
