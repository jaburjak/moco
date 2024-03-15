"
Represents a table in an Oracle Database.
"
Class {
	#name : #MocoRdbTable,
	#superclass : #Object,
	#instVars : [
		'name',
		'columns',
		'constraints'
	],
	#category : #'Moco-Rdb-Model'
}

{ #category : #accessing }
MocoRdbTable >> columns [
	^ columns
]

{ #category : #accessing }
MocoRdbTable >> constraints [
	^ constraints
]

{ #category : #initialization }
MocoRdbTable >> initialize [
	super initialize.
	
	name := ''.
	columns := OrderedCollection new.
	constraints := OrderedCollection new
]

{ #category : #accessing }
MocoRdbTable >> name [
	^ name
]

{ #category : #accessing }
MocoRdbTable >> name: aString [
	name := aString
]

{ #category : #printing }
MocoRdbTable >> printTo: aStream [
	aStream
		nextPutAll: '+--RDB-----------';
		cr;
		nextPutAll: '| <<Table>>';
		cr;
		nextPutAll: '| ' , name;
		cr.
	
	columns do: [ :each |
		aStream nextPutAll: '| * '.
		each printTo: aStream.
		aStream cr.
	].
	
	constraints do: [ :each |
		aStream nextPutAll: '| + '.
		each printTo: aStream.
		aStream cr.
	].
	
	aStream nextPutAll: '+----------------'.
]
