"
Represents a fact definition in an Alloy specification.
"
Class {
	#name : #MocoAlloyFact,
	#superclass : #Object,
	#instVars : [
		'name',
		'body'
	],
	#category : #'Moco-Alloy-Model'
}

{ #category : #accessing }
MocoAlloyFact >> body [
	^ body
]

{ #category : #accessing }
MocoAlloyFact >> body: aString [
	body := aString
]

{ #category : #initialization }
MocoAlloyFact >> initialize [
	super initialize.

	name := ''.
	body := ''
]

{ #category : #accessing }
MocoAlloyFact >> name [
	^ name
]

{ #category : #accessing }
MocoAlloyFact >> name: aString [
	name := aString
]

{ #category : #printing }
MocoAlloyFact >> printTo: aStream [
	aStream nextPutAll: 'fact '.

	name ifNotEmpty: [ aStream nextPutAll: name; nextPutAll: ' ' ].

	aStream nextPutAll: '{'.

	body ifNotEmpty: [
		aStream cr;
			nextPutAll: '    ';
			nextPutAll: (body copyReplaceAll: (String cr) with: ((String cr) , '    '));
			cr
	].

	aStream nextPutAll: '}'
]
