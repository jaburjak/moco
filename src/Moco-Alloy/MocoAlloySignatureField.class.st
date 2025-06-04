"
Represents a signature field in an Alloy specification.
"
Class {
	#name : #MocoAlloySignatureField,
	#superclass : #Object,
	#instVars : [
		'name',
		'multiplicity',
		'signature'
	],
	#category : #'Moco-Alloy-Model'
}

{ #category : #initialization }
MocoAlloySignatureField >> initialize [
	super initialize.

	name := ''.
	multiplicity := #set.
	signature := 'univ'.
]

{ #category : #accessing }
MocoAlloySignatureField >> multiplicity [
	^ multiplicity
]

{ #category : #accessing }
MocoAlloySignatureField >> multiplicity: aString [
	multiplicity := aString
]

{ #category : #accessing }
MocoAlloySignatureField >> name [
	^ name
]

{ #category : #accessing }
MocoAlloySignatureField >> name: aString [
	name := aString
]

{ #category : #printing }
MocoAlloySignatureField >> printTo: aStream [
	aStream nextPutAll: name;
		nextPutAll: ': ';
		nextPutAll: multiplicity;
		nextPutAll: ' ';
		nextPutAll: signature
]

{ #category : #accessing }
MocoAlloySignatureField >> signature [
	^ signature
]

{ #category : #accessing }
MocoAlloySignatureField >> signature: aString [
	signature := aString
]
