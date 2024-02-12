"
Represents a OntoUML Kind.
"
Class {
	#name : #MocoOntoUmlKind,
	#superclass : #MocoOntoUmlModelElement,
	#instVars : [
		'name',
		'abstract',
		'attributes'
	],
	#category : #'Moco-OntoUml-Model'
}

{ #category : #accessing }
MocoOntoUmlKind >> abstract [
	^ abstract
]

{ #category : #accessing }
MocoOntoUmlKind >> abstract: aBoolean [
	abstract := aBoolean
]

{ #category : #accessing }
MocoOntoUmlKind >> attributes [
	^ attributes
]

{ #category : #initialization }
MocoOntoUmlKind >> initialize [
	super initialize.
	
	abstract := false.
	attributes := OrderedCollection new.
]

{ #category : #accessing }
MocoOntoUmlKind >> name [
	^ name
]

{ #category : #accessing }
MocoOntoUmlKind >> name: aString [
	name := aString
]

{ #category : #printing }
MocoOntoUmlKind >> printTo: aStream [
	aStream
		nextPutAll: '|--OntoUML-------';
		cr;
		nextPutAll: '| <<Kind>>';
		cr;
		nextPutAll: '| ' , name;
		cr.

	attributes do: [ :each | each printTo: aStream. aStream cr. ].

	aStream
		nextPutAll: '|----------------'.
]
