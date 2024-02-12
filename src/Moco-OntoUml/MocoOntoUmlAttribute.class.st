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
		'multiplicity',
		'type'
	],
	#category : #'Moco-OntoUml-Model'
}

{ #category : #initialization }
MocoOntoUmlAttribute >> initialize [
	super initialize.
	
	static := false.
	visibility := MocoUmlVisibility public.
	multiplicity := MocoUmlMultiplicity new.
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
	name := aString
]

{ #category : #printing }
MocoOntoUmlAttribute >> printTo: aStream [
	aStream nextPutAll: '| '.
	static ifTrue: [ aStream nextPutAll: '_' ].
	visibility printTo: aStream.
	aStream nextPutAll: ' ' , name.
	type ifNotNil: [ aStream nextPutAll: ' : ' , type ].
	aStream nextPutAll: ' '.
	multiplicity printTo: aStream.
]

{ #category : #accessing }
MocoOntoUmlAttribute >> static [
	^ static
]

{ #category : #accessing }
MocoOntoUmlAttribute >> static: aBoolean [
	static := aBoolean
]

{ #category : #accessing }
MocoOntoUmlAttribute >> type [
	^ type
]

{ #category : #accessing }
MocoOntoUmlAttribute >> type: aString [
	type := aString
]

{ #category : #accessing }
MocoOntoUmlAttribute >> visibility [
	^ visibility
]

{ #category : #accessing }
MocoOntoUmlAttribute >> visibility: aVisibility [
	visibility := aVisibility
]
