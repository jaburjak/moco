"
Prints a model.
"
Class {
	#name : 'MocoModelPrinter',
	#superclass : 'Object',
	#category : 'Moco-OpenPonk-Utils',
	#package : 'Moco-OpenPonk',
	#tag : 'Utils'
}

{ #category : 'printing' }
MocoModelPrinter class >> print: aMocoModel to: aStream [
	| first |
	
	first := true.
	
	(aMocoModel elements) do: [ :each |
		first ifFalse: [ aStream cr; cr ].
		
		each printTo: aStream.
		
		first := false
	].
]
