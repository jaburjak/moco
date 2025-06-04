"
Represents a class attribute in a UML model.
"
Class {
	#name : #MocoUmlAttribute,
	#superclass : #Object,
	#instVars : [
		'name',
		'visibility',
		'static',
		'immutable',
		'multiplicity',
		'type',
		'ordered'
	],
	#category : #'Moco-Uml-Model'
}

{ #category : #accessing }
MocoUmlAttribute >> immutable [
	^ immutable
]

{ #category : #accessing }
MocoUmlAttribute >> immutable: aBoolean [
	immutable := aBoolean
]

{ #category : #initialization }
MocoUmlAttribute >> initialize [
	super initialize.
	
	name := ''.
	static := false.
	visibility := MocoUmlVisibility public.
	multiplicity := MocoUmlMultiplicity new.
	immutable := false.
	ordered := false
]

{ #category : #accessing }
MocoUmlAttribute >> multiplicity [
	^ multiplicity
]

{ #category : #accessing }
MocoUmlAttribute >> name [
	^ name
]

{ #category : #accessing }
MocoUmlAttribute >> name: aString [
	aString ifNil: [
		name := ''
	] ifNotNil: [
		name := aString
	]
]

{ #category : #accessing }
MocoUmlAttribute >> ordered [
	^ ordered
]

{ #category : #accessing }
MocoUmlAttribute >> ordered: aBoolean [
	ordered := aBoolean
]

{ #category : #printing }
MocoUmlAttribute >> printTo: aStream [
	aStream nextPutAll: '| '.
	static ifTrue: [ aStream nextPutAll: '_' ].
	visibility printTo: aStream.
	aStream nextPutAll: ' ' , name.
	type ifNotNil: [ aStream nextPutAll: ' : ' , (type name) ].
	aStream nextPutAll: ' '.
	multiplicity printTo: aStream.
	
	immutable ifTrue: [ aStream nextPutAll: ' {readOnly}' ].
	ordered ifTrue: [ aStream nextPutAll: ' {ordered}' ]
]

{ #category : #accessing }
MocoUmlAttribute >> static [
	^ static
]

{ #category : #accessing }
MocoUmlAttribute >> static: aBoolean [
	aBoolean ifNil: [
		static := false
	] ifNotNil: [
		static := aBoolean
	]
]

{ #category : #accessing }
MocoUmlAttribute >> type [
	^ type
]

{ #category : #accessing }
MocoUmlAttribute >> type: aMocoUmlType [
	type := aMocoUmlType
]

{ #category : #accessing }
MocoUmlAttribute >> visibility [
	^ visibility
]

{ #category : #accessing }
MocoUmlAttribute >> visibility: aVisibility [
	aVisibility ifNil: [
		visibility := MocoUmlVisibility public.
	] ifNotNil: [
		visibility := aVisibility
	]
]
