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

{ #category : #testing }
MocoUmlAssociation >> anySideIncludes: anObject [
	"Returns true if the association has the given object at either side."
	
	^ ((source element) == anObject) or: [ (target element) == anObject ]
]

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
		nextPutAll: '+--UML-----------';
		cr;
		nextPutAll: '| <<Association>>';
		cr.
	
	(derived or: [ name isNotEmpty ]) ifTrue: [
		aStream
			nextPutAll: '| ' , (derived ifTrue: [ '/' ] ifFalse: [ '' ]), name;
			cr
	].

	aStream nextPutAll: '| '.
	source printTo: aStream.
	
	aStream cr; nextPutAll: '| '.
	target printTo: aStream.

	aStream
		cr;
		nextPutAll: '+----------------'.
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
