"
Prints a model.
"
Class {
	#name : #MocoModelPrinter,
	#superclass : #Object,
	#category : #'Moco-Core-Utils'
}

{ #category : #printing }
MocoModelPrinter class >> print: aModel to: aStream [
	| elements first |
	elements := aModel elements collect: [ :each | each innerElement ].
	
	first := true.
	
	elements do: [ :each |
		first ifFalse: [ aStream cr; cr ].
		
		each printTo: aStream.
		
		first := false
	].
]
