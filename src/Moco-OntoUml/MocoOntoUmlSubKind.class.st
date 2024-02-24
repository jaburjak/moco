"
Represents an OntoUML Kind.
"
Class {
	#name : #MocoOntoUmlSubKind,
	#superclass : #MocoOntoUmlModelElement,
	#instVars : [
		'name',
		'abstract',
		'attributes'
	],
	#category : #'Moco-OntoUml-Model'
}

{ #category : #accessing }
MocoOntoUmlSubKind >> abstract [
	^ abstract
]

{ #category : #accessing }
MocoOntoUmlSubKind >> abstract: aBoolean [
	abstract := aBoolean
]

{ #category : #accessing }
MocoOntoUmlSubKind >> attributes [
	^ attributes
]

{ #category : #initialization }
MocoOntoUmlSubKind >> initialize [
	super initialize.
	
	abstract := false.
	attributes := OrderedCollection new.
]

{ #category : #accessing }
MocoOntoUmlSubKind >> name [
	^ name
]

{ #category : #accessing }
MocoOntoUmlSubKind >> name: aString [
	name := aString
]

{ #category : #printing }
MocoOntoUmlSubKind >> printTo: aStream [
	aStream
		nextPutAll: '|--OntoUML-------';
		cr;
		nextPutAll: '| <<SubKind>>';
		cr;
		nextPutAll: '| ' , name;
		cr.

	attributes do: [ :each | each printTo: aStream. aStream cr. ].

	aStream
		nextPutAll: '|----------------'.
]
