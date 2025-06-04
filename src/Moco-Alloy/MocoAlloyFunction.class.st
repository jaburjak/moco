"
Represents a function definition in an Alloy specification.
"
Class {
	#name : #MocoAlloyFunction,
	#superclass : #Object,
	#instVars : [
		'name',
		'arguments',
		'output',
		'body'
	],
	#category : #'Moco-Alloy-Model'
}

{ #category : #accessing }
MocoAlloyFunction >> arguments [
	^ arguments
]

{ #category : #accessing }
MocoAlloyFunction >> body [
	^ body
]

{ #category : #accessing }
MocoAlloyFunction >> body: aString [
	body := aString
]

{ #category : #initialization }
MocoAlloyFunction >> initialize [
	super initialize.

	name := ''.
	arguments := MocoAlloyPredicateArguments new.
	output := ''.
	body := ''
]

{ #category : #accessing }
MocoAlloyFunction >> name [
	^ name
]

{ #category : #accessing }
MocoAlloyFunction >> name: aString [
	name := aString
]

{ #category : #accessing }
MocoAlloyFunction >> output [
	^ output
]

{ #category : #accessing }
MocoAlloyFunction >> output: aString [
	output := aString
]

{ #category : #printing }
MocoAlloyFunction >> printTo: aStream [
	aStream nextPutAll: 'fun ';
		nextPutAll: name;
		nextPutAll: '['.

	arguments printTo: aStream.

	aStream nextPutAll: ']'.

	output ifNotEmpty: [ aStream nextPutAll: ': '; nextPutAll: output ].

	aStream nextPutAll: ' {'.

	body ifNotEmpty: [
		aStream cr; nextPutAll: '    ';
			nextPutAll: (body copyReplaceAll: (String cr) with: ((String cr) , '    ')).
	].

	aStream cr; nextPutAll: '}'
]
