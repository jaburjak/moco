"
Represents an enumeration in a UML model.
"
Class {
	#name : #MocoUmlEnumeration,
	#superclass : #MocoUmlModelElement,
	#instVars : [
		'name',
		'literals'
	],
	#category : #'Moco-Uml-Model'
}

{ #category : #initialization }
MocoUmlEnumeration >> initialize [
	super initialize.
	
	name := ''.
	literals := OrderedCollection new
]

{ #category : #accessing }
MocoUmlEnumeration >> literals [
	^ literals
]

{ #category : #accessing }
MocoUmlEnumeration >> name [
	^ name
]

{ #category : #accessing }
MocoUmlEnumeration >> name: aString [
	aString ifNil: [
		name := ''
	] ifNotNil: [
		name := aString
	]
]

{ #category : #printing }
MocoUmlEnumeration >> printTo: aStream [
	aStream
		nextPutAll: '+--UML-----------';
		cr;
		nextPutAll: '| <<Enumeration>>';
		cr;
		nextPutAll: '| ';
		nextPutAll: name;
		cr.
	
	literals do: [ :each |
		aStream nextPutAll: '| + '.
		each printTo: aStream.
		aStream cr
	].
	
	aStream
		nextPutAll: '+----------------'
]
