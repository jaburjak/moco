"
Represents a class in an OntoUML model.
"
Class {
	#name : #MocoOntoUmlClass,
	#superclass : #MocoOntoUmlModelElement,
	#instVars : [
		'name',
		'abstract',
		'attributes'
	],
	#category : #'Moco-OntoUml-Model'
}

{ #category : #accessing }
MocoOntoUmlClass >> abstract [
	^ abstract
]

{ #category : #accessing }
MocoOntoUmlClass >> abstract: aBoolean [
	aBoolean ifNil: [
		abstract := false
	] ifNotNil: [
		abstract := aBoolean
	]
]

{ #category : #accessing }
MocoOntoUmlClass >> attributes [
	^ attributes
]

{ #category : #initialization }
MocoOntoUmlClass >> initialize [
	super initialize.
	
	name := ''.
	abstract := false.
	attributes := OrderedCollection new.
]

{ #category : #accessing }
MocoOntoUmlClass >> isSortal [
	^ true
]

{ #category : #accessing }
MocoOntoUmlClass >> name [
	^ name
]

{ #category : #accessing }
MocoOntoUmlClass >> name: aString [
	aString ifNil: [
		name := ''
	] ifNotNil: [
		name := aString
	]
]

{ #category : #printing }
MocoOntoUmlClass >> printTo: aStream [
	aStream
		nextPutAll: '+--OntoUML-------';
		cr;
		nextPutAll: '| <<' , (self class asString copyReplaceAll: 'MocoOntoUml' with: '') , '>>';
		cr;
		nextPutAll: '| ' , name;
		cr.

	attributes do: [ :each | each printTo: aStream. aStream cr. ].

	aStream
		nextPutAll: '+----------------'.
]

{ #category : #accessing }
MocoOntoUmlClass >> providesIdentity [
	^ true
]
