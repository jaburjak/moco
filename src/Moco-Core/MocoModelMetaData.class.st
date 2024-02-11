"
Holds additional meta data about a WrappedModel.
"
Class {
	#name : #MocoModelMetaData,
	#superclass : #Object,
	#instVars : [
		'didChange'
	],
	#category : #'Moco-Core-Model'
}

{ #category : #accessing }
MocoModelMetaData >> didChange [
	^ didChange
]

{ #category : #accessing }
MocoModelMetaData >> didChange: aBoolean [
	didChange := aBoolean
]

{ #category : #initialization }
MocoModelMetaData >> initialize [
	super initialize.
	
	didChange := false
]
