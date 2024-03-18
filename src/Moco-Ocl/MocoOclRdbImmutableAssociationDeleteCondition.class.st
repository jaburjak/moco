"
Represents a DELETE OCL precondition for immutable associations.
"
Class {
	#name : #MocoOclRdbImmutableAssociationDeleteCondition,
	#superclass : #MocoOclPostCondition,
	#instVars : [
		'column',
		'targetTable',
		'targetColumn'
	],
	#category : #'Moco-Ocl-Model'
}

{ #category : #accessing }
MocoOclRdbImmutableAssociationDeleteCondition >> column [
	^ column
]

{ #category : #accessing }
MocoOclRdbImmutableAssociationDeleteCondition >> column: aMocoRdbColumn [
	column := aMocoRdbColumn
]

{ #category : #printing }
MocoOclRdbImmutableAssociationDeleteCondition >> printOclTo: aStream [
	| varName |
	
	super printOclTo: aStream.

	varName := MocoNamingUtils toShortName: (targetTable name).

	aStream
		nextPutAll: 'self.';
		nextPutAll: (column name);
		nextPutAll: ' = OclVoid OR NOT(';
		nextPutAll: (targetTable name);
		nextPutAll: '.allInstances()->exists(';
		nextPutAll: varName;
		nextPutAll: ' | ';
		nextPutAll: varName;
		nextPutAll: '.';
		nextPutAll: (targetColumn name);
		nextPutAll: ' = self.';
		nextPutAll: (column name);
		nextPutAll: '@pre))'
]

{ #category : #accessing }
MocoOclRdbImmutableAssociationDeleteCondition >> targetColumn [
	^ targetColumn
]

{ #category : #accessing }
MocoOclRdbImmutableAssociationDeleteCondition >> targetColumn: aMocoRdbColumn [
	targetColumn := aMocoRdbColumn
]

{ #category : #accessing }
MocoOclRdbImmutableAssociationDeleteCondition >> targetTable [
	^ targetTable
]

{ #category : #accessing }
MocoOclRdbImmutableAssociationDeleteCondition >> targetTable: aMocoRdbTable [
	targetTable := aMocoRdbTable
]
