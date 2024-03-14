"
Represents a column of a database table.
"
Class {
	#name : #MocoRdbColumn,
	#superclass : #Object,
	#instVars : [
		'name',
		'type',
		'nullable'
	],
	#category : #'Moco-Rdb-Model'
}

{ #category : #initialization }
MocoRdbColumn >> initialize [
	super initialize.
	
	name := ''.
	nullable := true
]

{ #category : #accessing }
MocoRdbColumn >> name [
	^ name
]

{ #category : #accessing }
MocoRdbColumn >> name: aString [
	name := aString
]

{ #category : #accessing }
MocoRdbColumn >> nullable [
	^ nullable
]

{ #category : #accessing }
MocoRdbColumn >> nullable: aBoolean [
	nullable := aBoolean
]

{ #category : #printing }
MocoRdbColumn >> printTo: aStream [

	aStream
		nextPutAll: name;
		nextPutAll: ' '.

	type ifNotNil: [
		aStream
			nextPutAll: ': ';
			nextPutAll: (type typeDefinition);
			nextPutAll: ' ' ].

	aStream nextPutAll: (nullable
			 ifTrue: [ 'NULLABLE' ]
			 ifFalse: [ 'NOT NULL' ])
]

{ #category : #accessing }
MocoRdbColumn >> type [
	^ type
]

{ #category : #accessing }
MocoRdbColumn >> type: aMocoRdbDataType [
	type := aMocoRdbDataType
]
