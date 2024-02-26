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
	abstract := aBoolean
]

{ #category : #accessing }
MocoOntoUmlClass >> attributes [
	^ attributes
]

{ #category : #initialization }
MocoOntoUmlClass >> initialize [
	super initialize.
	
	abstract := false.
	attributes := OrderedCollection new.
]

{ #category : #accessing }
MocoOntoUmlClass >> name [
	^ name
]

{ #category : #accessing }
MocoOntoUmlClass >> name: aString [
	name := aString
]

{ #category : #printing }
MocoOntoUmlClass >> printTo: aStream [
	aStream
		nextPutAll: '|--OntoUML-------';
		cr;
		nextPutAll: '| <<' , (self class asString copyReplaceAll: 'MocoOntoUml' with: '') , '>>';
		cr;
		nextPutAll: '| ' , name;
		cr.

	attributes do: [ :each | each printTo: aStream. aStream cr. ].

	aStream
		nextPutAll: '|----------------'.
]
