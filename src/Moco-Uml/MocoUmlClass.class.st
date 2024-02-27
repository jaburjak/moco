"
Represents a UML Class.
"
Class {
	#name : #MocoUmlClass,
	#superclass : #MocoUmlModelElement,
	#instVars : [
		'name',
		'abstract',
		'attributes'
	],
	#category : #'Moco-Uml-Model'
}

{ #category : #accessing }
MocoUmlClass >> abstract [
	^ abstract
]

{ #category : #accessing }
MocoUmlClass >> abstract: aBoolean [
	aBoolean ifNil: [
		abstract := false
	] ifNotNil: [
		abstract := aBoolean
	]
]

{ #category : #accessing }
MocoUmlClass >> attributes [
	^ attributes
]

{ #category : #initialization }
MocoUmlClass >> initialize [
	super initialize.
	
	abstract := false.
	attributes := OrderedCollection new.
]

{ #category : #accessing }
MocoUmlClass >> name [
	^ name
]

{ #category : #accessing }
MocoUmlClass >> name: aString [
	aString ifNil: [
		name := ''
	] ifNotNil: [
		name := aString
	]
]

{ #category : #printing }
MocoUmlClass >> printTo: aStream [
	aStream
		nextPutAll: '|--UML-----------';
		cr;
		nextPutAll: '| <<Class>>';
		cr;
		nextPutAll: '| ' , name;
		cr.

	attributes do: [ :each | each printTo: aStream. aStream cr. ].

	aStream
		nextPutAll: '|----------------'.
]
