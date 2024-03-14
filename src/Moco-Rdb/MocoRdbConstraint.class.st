"
Base class for table column constraints in a relational database.
"
Class {
	#name : #MocoRdbConstraint,
	#superclass : #Object,
	#instVars : [
		'name'
	],
	#category : #'Moco-Rdb-Model'
}

{ #category : #'instance creation' }
MocoRdbConstraint class >> new [
	(self asString = 'MocoRdbConstraint') ifTrue: [ ^ self subclassResponsibility ] ifFalse: [ ^ super new ]
]

{ #category : #initialization }
MocoRdbConstraint >> initialize [
	super initialize.
	
	name := ''
]

{ #category : #accessing }
MocoRdbConstraint >> name [
	^ name
]

{ #category : #accessing }
MocoRdbConstraint >> name: aString [
	name := aString
]

{ #category : #printing }
MocoRdbConstraint >> printTo: aStream [
	aStream nextPutAll: name
]
