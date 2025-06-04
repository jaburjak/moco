"
Represents a signature in an Alloy specification.
"
Class {
	#name : #MocoAlloySignature,
	#superclass : #Object,
	#instVars : [
		'abstract',
		'multiplicity',
		'name',
		'subset',
		'fields',
		'facts'
	],
	#category : #'Moco-Alloy-Model'
}

{ #category : #accessing }
MocoAlloySignature >> abstract [
	^ abstract
]

{ #category : #accessing }
MocoAlloySignature >> abstract: aBoolean [
	abstract := aBoolean
]

{ #category : #accessing }
MocoAlloySignature >> facts [
	^ facts
]

{ #category : #accessing }
MocoAlloySignature >> fields [
	^ fields
]

{ #category : #initialization }
MocoAlloySignature >> initialize [
	super initialize.

	abstract := false.
	multiplicity := ''.
	name := ''.
	subset := ''.
	fields := OrderedCollection new.
	facts := OrderedCollection new.
]

{ #category : #accessing }
MocoAlloySignature >> multiplicity [
	^ multiplicity
]

{ #category : #accessing }
MocoAlloySignature >> multiplicity: aString [
	^ aString
]

{ #category : #accessing }
MocoAlloySignature >> name [
	^ name
]

{ #category : #accessing }
MocoAlloySignature >> name: aString [
	name := aString
]

{ #category : #printing }
MocoAlloySignature >> printTo: aStream [
	abstract ifTrue: [ aStream nextPutAll: 'abstract ' ].

	multiplicity ifNotEmpty: [ aStream nextPutAll: multiplicity; nextPutAll: ' ' ].

	aStream nextPutAll: 'sig ';
		nextPutAll: name;
		nextPutAll: ' '.

	subset ifNotEmpty: [ aStream nextPutAll: subset; nextPutAll: ' ' ].

	aStream nextPutAll: '{'.

	fields doWithIndex: [ :each :i |
		(i > 1) ifTrue: [ aStream nextPutAll: ',' ].
		aStream cr; nextPutAll: '    '.
		each printTo: aStream.
	].

	fields ifNotEmpty: [ aStream cr ].

	aStream nextPutAll: '}'.

	facts ifNotEmpty: [
		aStream nextPutAll: ' {'.

		facts do: [ :e | aStream cr; nextPutAll: '    '. e printTo: aStream ].

		aStream cr; nextPutAll: '}'
	]
]

{ #category : #accessing }
MocoAlloySignature >> subset [
	^ subset
]

{ #category : #accessing }
MocoAlloySignature >> subset: aString [
	subset := aString
]
