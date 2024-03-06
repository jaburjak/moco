"
Utilities for transforming element names.
"
Class {
	#name : #MocoNamingUtils,
	#superclass : #Object,
	#category : #'Moco-Core-Utils'
}

{ #category : #transforming }
MocoNamingUtils class >> toCamelCase: aString [
	| str |
	str := aString asCamelCase.
	str := (str first asLowercase asString) , (str allButFirst: 1).
	
	^ str
]

{ #category : #transforming }
MocoNamingUtils class >> toPascalCase: aString [
	^ aString asCamelCase
]

{ #category : #transforming }
MocoNamingUtils class >> toUpperSnakeCase: aString [
	| str |
	str := OrderedCollection new.

	aString do: [ :l | (l isLetter and: (l = (l asUppercase))) ifTrue: [ str add: '_' ]. str add: l asString asUppercase ].

	(str first = '_') ifTrue: [ str := str allButFirst: 1 ].

	str := String streamContents: [ :stream | str do: [ :each | (each = ' ') ifTrue: [ stream nextPutAll: '_' ] ifFalse: [ stream nextPutAll: each ] ] ].
	
	^ str
]
