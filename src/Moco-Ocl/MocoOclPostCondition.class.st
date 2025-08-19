"
Base class that represents an OCL postcondition.
"
Class {
	#name : 'MocoOclPostCondition',
	#superclass : 'MocoOclCondition',
	#category : 'Moco-Ocl-Model',
	#package : 'Moco-Ocl',
	#tag : 'Model'
}

{ #category : 'accessing' }
MocoOclPostCondition class >> type [
	^ #post
]

{ #category : 'initialization' }
MocoOclPostCondition >> initialize [
	super initialize.
	
	operation := #UPDATE
]
