"
Represents an enumeration in an Alloy specification.
"
Class {
	#name : #MocoAlloyEnumeration,
	#superclass : #Object,
	#instVars : [
		'name',
		'literals'
	],
	#category : #'Moco-Alloy-Model'
}

{ #category : #adding }
MocoAlloyEnumeration >> addLiteral: aString [
	literals add: aString
]

{ #category : #initialization }
MocoAlloyEnumeration >> initialize [
	super initialize.

	name := ''.
	literals := OrderedCollection new
]

{ #category : #accessing }
MocoAlloyEnumeration >> literals [
	^ literals
]

{ #category : #accessing }
MocoAlloyEnumeration >> name [
	^ name
]

{ #category : #accessing }
MocoAlloyEnumeration >> name: aString [
	name := aString
]

{ #category : #printing }
MocoAlloyEnumeration >> printTo: aStream [
	aStream nextPutAll: 'enum ';
		nextPutAll: name;
		nextPutAll: ' {'.

	literals withIndexDo: [ :l :i |
		(i > 1) ifTrue: [ aStream nextPutAll: ', ' ].
		aStream nextPutAll: l
	].

	aStream nextPutAll: '}'
]
