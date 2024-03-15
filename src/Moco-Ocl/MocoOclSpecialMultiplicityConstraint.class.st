"
Represents a special multiplicity constraint in an RDB model.
"
Class {
	#name : #MocoOclSpecialMultiplicityConstraint,
	#superclass : #MocoOclInvariant,
	#instVars : [
		'lower',
		'upper',
		'targetColumn',
		'sourceTable',
		'sourceColumn'
	],
	#category : #'Moco-Ocl-Model'
}

{ #category : #accessing }
MocoOclSpecialMultiplicityConstraint >> lower [
	^ lower
]

{ #category : #accessing }
MocoOclSpecialMultiplicityConstraint >> lower: aNumber [
	lower := aNumber
]

{ #category : #printing }
MocoOclSpecialMultiplicityConstraint >> printTo: aStream [
	| varName |
	
	super printTo: aStream.
	
	varName := sourceTable name first asString asLowercase.
	
	aStream
		nextPutAll: '| def count: Integer =';
		cr;
		nextPutAll: '|   ';
		nextPutAll: (sourceTable name);
		nextPutAll: '.allInstances()->count(';
		nextPutAll: varName;
		nextPutAll: ' | ';
		nextPutAll: varName;
		nextPutAll: '.';
		nextPutAll: (sourceColumn name);
		nextPutAll: ' = self.';
		nextPutAll: (targetColumn name);
		nextPutAll: ')';
		cr;
		nextPutAll: '| '.
	
	lower ifNotNil: [
		aStream nextPutAll: (lower asString); nextPutAll: ' <= count'.
		
		upper ifNotNil: [ aStream nextPutAll: ' AND ' ]
	].

	upper ifNotNil: [
		aStream nextPutAll: 'count <= '; nextPutAll: (upper asString)
	].
	
	aStream cr;
		nextPutAll: '+----------------'
]

{ #category : #accessing }
MocoOclSpecialMultiplicityConstraint >> sourceColumn [
	^ sourceColumn
]

{ #category : #accessing }
MocoOclSpecialMultiplicityConstraint >> sourceColumn: aMocoRdbColumn [
	sourceColumn := aMocoRdbColumn
]

{ #category : #accessing }
MocoOclSpecialMultiplicityConstraint >> sourceTable [
	^ sourceTable
]

{ #category : #accessing }
MocoOclSpecialMultiplicityConstraint >> sourceTable: aMocoRdbTable [
	sourceTable := aMocoRdbTable
]

{ #category : #accessing }
MocoOclSpecialMultiplicityConstraint >> targetColumn [
	^ targetColumn
]

{ #category : #accessing }
MocoOclSpecialMultiplicityConstraint >> targetColumn: aMocoRdbColumn [
	targetColumn := aMocoRdbColumn
]

{ #category : #accessing }
MocoOclSpecialMultiplicityConstraint >> upper [
	^ upper
]

{ #category : #accessing }
MocoOclSpecialMultiplicityConstraint >> upper: aNumber [
	upper := aNumber
]
