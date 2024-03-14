"
Represents a FOREIGN KEY constraint in a relational database.
"
Class {
	#name : #MocoRdbForeignKey,
	#superclass : #MocoRdbConstraint,
	#instVars : [
		'columns',
		'reference'
	],
	#category : #'Moco-Rdb-Model'
}

{ #category : #'instance creation' }
MocoRdbForeignKey class >> newAtColumn: aMocoRdbColumn referencingTable: aMocoRdbTable andColumn: aMocoRdbColumn2 [
	| inst |
	inst := self new.
	
	inst name: ('FK_' , (aMocoRdbColumn name)).
	inst columns add: aMocoRdbColumn.
	inst reference add: { aMocoRdbTable. aMocoRdbColumn2 }.
	
	^ inst
]

{ #category : #accessing }
MocoRdbForeignKey >> columns [
	^ columns
]

{ #category : #initialization }
MocoRdbForeignKey >> initialize [
	super initialize.
	
	columns := OrderedCollection new.
	reference := OrderedCollection new
]

{ #category : #printing }
MocoRdbForeignKey >> printTo: aStream [
	aStream nextPutAll: '<<FK>> '.

	super printTo: aStream.
	
	aStream
		nextPutAll: '(';
		nextPutAll: (', ' join: (columns with: reference collect: [ :c :r | (c name) , '=' , (r first name) , '.' , (r last name) ]));
		nextPutAll: ')'
]

{ #category : #accessing }
MocoRdbForeignKey >> reference [
	^ reference
]
