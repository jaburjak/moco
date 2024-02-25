"
Represents an OntoUML association.
"
Class {
	#name : #MocoOntoUmlAssociation,
	#superclass : #MocoOntoUmlModelElement,
	#instVars : [
		'name',
		'derived',
		'source',
		'target'
	],
	#category : #'Moco-OntoUml-Model'
}

{ #category : #accessing }
MocoOntoUmlAssociation >> derived [
	^ derived
]

{ #category : #accessing }
MocoOntoUmlAssociation >> derived: aBoolean [
	derived := aBoolean
]

{ #category : #initialization }
MocoOntoUmlAssociation >> initialize [
	super initialize.

	name := ''.
	derived := false.
	source := MocoOntoUmlAssociationSide new.
	target := MocoOntoUmlAssociationSide new.
	
	^ self
]

{ #category : #accessing }
MocoOntoUmlAssociation >> name [
	^ name
]

{ #category : #accessing }
MocoOntoUmlAssociation >> name: aString [
	name := aString
]

{ #category : #printing }
MocoOntoUmlAssociation >> printTo: aStream [
	aStream
		nextPutAll: '|--OntoUML-------';
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
MocoOntoUmlAssociation >> source [
	^ source
]

{ #category : #accessing }
MocoOntoUmlAssociation >> source: aSide [
	source := aSide
]

{ #category : #accessing }
MocoOntoUmlAssociation >> target [
	^ target
]

{ #category : #accessing }
MocoOntoUmlAssociation >> target: aSide [
	target := aSide
]
