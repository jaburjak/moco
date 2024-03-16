"
Represents a mandatory association multiplicity constraint in an RDB model.
"
Class {
	#name : #MocoOclMandatoryMultiplicityConstraint,
	#superclass : #MocoOclInvariant,
	#instVars : [
		'targetColumn',
		'sourceTable',
		'sourceColumn'
	],
	#category : #'Moco-Ocl-Model'
}

{ #category : #printing }
MocoOclMandatoryMultiplicityConstraint >> printTo: aStream [
	| varName |
	
	super printTo: aStream.
	
	varName := MocoNamingUtils toShortName: (sourceTable name).
	
	aStream
		nextPutAll: '| ';
		nextPutAll: (sourceTable name);
		nextPutAll: '.allInstances()->exists(';
		nextPutAll: varName;
		nextPutAll: ' | ';
		nextPutAll: varName;
		nextPutAll: '.';
		nextPutAll: (sourceColumn name);
		nextPutAll: ' = self.';
		nextPutAll: (targetColumn name);
		nextPutAll: ')';
		cr;
		nextPutAll: '+----------------'
]

{ #category : #accessing }
MocoOclMandatoryMultiplicityConstraint >> sourceColumn [
	^ sourceColumn
]

{ #category : #accessing }
MocoOclMandatoryMultiplicityConstraint >> sourceColumn: aMocoRdbColumn [
	sourceColumn := aMocoRdbColumn
]

{ #category : #accessing }
MocoOclMandatoryMultiplicityConstraint >> sourceTable [
	^ sourceTable
]

{ #category : #accessing }
MocoOclMandatoryMultiplicityConstraint >> sourceTable: aMocoRdbTable [
	sourceTable := aMocoRdbTable
]

{ #category : #accessing }
MocoOclMandatoryMultiplicityConstraint >> targetColumn [
	^ targetColumn
]

{ #category : #accessing }
MocoOclMandatoryMultiplicityConstraint >> targetColumn: aMocoRdbColumn [
	targetColumn := aMocoRdbColumn
]
