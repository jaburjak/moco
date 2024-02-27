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
		'multiplicity',
		'type'
	],
	#category : #'Moco-Uml-Model'
}

{ #category : #initialization }
MocoUmlAttribute >> initialize [
	super initialize.
	
	static := false.
	visibility := MocoUmlVisibility public.
	multiplicity := MocoUmlMultiplicity new.
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
	name := aString
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
]

{ #category : #accessing }
MocoUmlAttribute >> static [
	^ static
]

{ #category : #accessing }
MocoUmlAttribute >> static: aBoolean [
	static := aBoolean
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
	visibility := aVisibility
]
