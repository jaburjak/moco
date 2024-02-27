"
Represents a UML association.
"
Class {
	#name : #MocoUmlAssociation,
	#superclass : #MocoUmlModelElement,
	#instVars : [
		'name',
		'derived',
		'source',
		'target'
	],
	#category : #'Moco-Uml-Model'
}

{ #category : #accessing }
MocoUmlAssociation >> derived [
	^ derived
]

{ #category : #accessing }
MocoUmlAssociation >> derived: aBoolean [
	aBoolean ifNil: [
		derived := false
	] ifNotNil: [
		derived := aBoolean
	]
]

{ #category : #accessing }
MocoUmlAssociation >> initialize [
	super initialize.
	
	name := ''.
	derived := false.
]

{ #category : #accessing }
MocoUmlAssociation >> name [
	^ name
]

{ #category : #accessing }
MocoUmlAssociation >> name: aString [
	aString ifNil: [
		name := ''
	] ifNotNil: [
		name := aString
	]
]

{ #category : #accessing }
MocoUmlAssociation >> printTo: aStream [
	aStream
		nextPutAll: '|--UML-----------';
		cr;
		nextPutAll: '| <<Association>>';
		cr;
		nextPutAll: '| ' , (derived ifTrue: [ '/' ] ifFalse: [ '' ]), name;
		cr;
		nextPutAll: '| '.

	source printTo: aStream.
	
	aStream cr; nextPutAll: '| '.
	target printTo: aStream.

	aStream
		cr;
		nextPutAll: '|----------------'.
]

{ #category : #accessing }
MocoUmlAssociation >> source [
	^ source
]

{ #category : #accessing }
MocoUmlAssociation >> source: aMocoUmlAssociationSide [
	source := aMocoUmlAssociationSide
]

{ #category : #accessing }
MocoUmlAssociation >> target [
	^ target
]

{ #category : #accessing }
MocoUmlAssociation >> target: aMocoUmlAssociationSide [
	target := aMocoUmlAssociationSide
]
