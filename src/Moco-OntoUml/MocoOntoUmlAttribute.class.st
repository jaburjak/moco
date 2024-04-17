"
Represents a class attribute in an OntoUML model.
"
Class {
	#name : #MocoOntoUmlAttribute,
	#superclass : #Object,
	#instVars : [
		'name',
		'visibility',
		'static',
		'immutable',
		'multiplicity',
		'type'
	],
	#category : #'Moco-OntoUml-Model'
}

{ #category : #accessing }
MocoOntoUmlAttribute >> immutable [
	^ immutable
]

{ #category : #accessing }
MocoOntoUmlAttribute >> immutable: aBoolean [
	immutable := aBoolean
]

{ #category : #initialization }
MocoOntoUmlAttribute >> initialize [
	super initialize.
	
	name := ''.
	static := false.
	visibility := MocoUmlVisibility public.
	multiplicity := MocoUmlMultiplicity new.
	immutable := false
]

{ #category : #accessing }
MocoOntoUmlAttribute >> multiplicity [
	^ multiplicity
]

{ #category : #accessing }
MocoOntoUmlAttribute >> name [
	^ name
]

{ #category : #accessing }
MocoOntoUmlAttribute >> name: aString [
	aString ifNil: [
		name := ''
	] ifNotNil: [
		name := aString
	]
]

{ #category : #printing }
MocoOntoUmlAttribute >> printTo: aStream [
	aStream nextPutAll: '| '.
	static ifTrue: [ aStream nextPutAll: '_' ].
	visibility printTo: aStream.
	aStream nextPutAll: ' ' , name.
	type ifNotNil: [ aStream nextPutAll: ' : ' , (type name) ].
	aStream nextPutAll: ' '.
	multiplicity printTo: aStream.
	
	immutable ifTrue: [ aStream nextPutAll: ' {readOnly}' ]
]

{ #category : #accessing }
MocoOntoUmlAttribute >> static [
	^ static
]

{ #category : #accessing }
MocoOntoUmlAttribute >> static: aBoolean [
	aBoolean ifNil: [
		static := false
	] ifNotNil: [
		static := aBoolean
	]
]

{ #category : #accessing }
MocoOntoUmlAttribute >> type [
	^ type
]

{ #category : #accessing }
MocoOntoUmlAttribute >> type: aMocoUmlType [
	type := aMocoUmlType
]

{ #category : #accessing }
MocoOntoUmlAttribute >> visibility [
	^ visibility
]

{ #category : #accessing }
MocoOntoUmlAttribute >> visibility: aVisibility [
	aVisibility ifNil: [
		visibility := MocoUmlVisibility public.
	] ifNotNil: [
		visibility := aVisibility
	]
]
