"
Holds additional meta data about a WrappedModel.
"
Class {
	#name : #ModelMetaData,
	#superclass : #Object,
	#instVars : [
		'didChange'
	],
	#category : #'Moco-Core-Model'
}

{ #category : #accessing }
ModelMetaData >> didChange [
	^ didChange
]

{ #category : #accessing }
ModelMetaData >> didChange: aBoolean [
	didChange := aBoolean
]

{ #category : #initialization }
ModelMetaData >> initialize [
	super initialize.
	
	didChange := false
]
