"
Represents a FOREIGN KEY constraint in a relational database.
"
Class {
	#name : #MocoRdbForeignKey,
	#superclass : #MocoRdbConstraint,
	#instVars : [
		'columns',
		'referencedTable',
		'referencedColumns'
	],
	#category : #'Moco-Rdb-Model'
}

{ #category : #'instance creation' }
MocoRdbForeignKey class >> newAtColumn: aMocoRdbColumn referencingTable: aMocoRdbTable andColumn: aMocoRdbColumn2 [
	"Instantiates a new FOREIGN KEY constraint that at aMocoRdbColumn which references aMocoRdbTable.aMocoRdbColumn2."
	
	| inst |
	inst := self new.
	
	inst name: ('FK_' , (aMocoRdbColumn name)).
	inst columns add: aMocoRdbColumn.
	inst referencedTable: aMocoRdbTable.
	inst referencedColumns add: aMocoRdbColumn2.
	
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
	referencedColumns := OrderedCollection new
]

{ #category : #printing }
MocoRdbForeignKey >> printTo: aStream [
	aStream nextPutAll: '<<FK>> '.

	super printTo: aStream.
	
	aStream
		nextPutAll: '(';
		nextPutAll: (', ' join: (columns with: referencedColumns collect: [ :c :r | (c name) , '=' , (referencedTable name) , '.' , (r name) ]));
		nextPutAll: ')'
]

{ #category : #accessing }
MocoRdbForeignKey >> referencedColumns [
	^ referencedColumns
]

{ #category : #accessing }
MocoRdbForeignKey >> referencedTable [
	^ referencedTable
]

{ #category : #accessing }
MocoRdbForeignKey >> referencedTable: aMocoRdbTable [
	referencedTable := aMocoRdbTable
]
