"
Prints a model.
"
Class {
	#name : #MocoModelPrinter,
	#superclass : #Object,
	#category : #'Moco-OpenPonk-Utils'
}

{ #category : #printing }
MocoModelPrinter class >> print: aModel to: aStream [
	| elements |
	elements := aModel elements collect: [ :each | each innerElement ].
	
	elements do: [ :each | each printTo: aStream. aStream cr. aStream cr. ].
]
