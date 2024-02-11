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

{ #category : #printing }
MocoModelPrinter class >> printToTranscript: aModel [
	| stream |
	stream := String new writeStream.

	self print: aModel to: stream.

	Transcript show: (stream contents).
]

{ #category : #printing }
MocoModelPrinter class >> printToTranscript: aModel withTitle: aString [
	Transcript show: '================================';
		cr;
		show: '== ' , aString;
		cr; cr.
	
	self printToTranscript: aModel.
]
