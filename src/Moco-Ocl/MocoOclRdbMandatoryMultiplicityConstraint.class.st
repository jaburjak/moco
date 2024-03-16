"
Represents a mandatory association multiplicity constraint in an RDB model.
"
Class {
	#name : #MocoOclRdbMandatoryMultiplicityConstraint,
	#superclass : #MocoOclInvariant,
	#instVars : [
		'targetColumn',
		'sourceTable',
		'sourceColumn'
	],
	#category : #'Moco-Ocl-Model'
}

{ #category : #printing }
MocoOclRdbMandatoryMultiplicityConstraint >> printTo: aStream [
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
MocoOclRdbMandatoryMultiplicityConstraint >> sourceColumn [
	^ sourceColumn
]

{ #category : #accessing }
MocoOclRdbMandatoryMultiplicityConstraint >> sourceColumn: aMocoRdbColumn [
	sourceColumn := aMocoRdbColumn
]

{ #category : #accessing }
MocoOclRdbMandatoryMultiplicityConstraint >> sourceTable [
	^ sourceTable
]

{ #category : #accessing }
MocoOclRdbMandatoryMultiplicityConstraint >> sourceTable: aMocoRdbTable [
	sourceTable := aMocoRdbTable
]

{ #category : #accessing }
MocoOclRdbMandatoryMultiplicityConstraint >> targetColumn [
	^ targetColumn
]

{ #category : #accessing }
MocoOclRdbMandatoryMultiplicityConstraint >> targetColumn: aMocoRdbColumn [
	targetColumn := aMocoRdbColumn
]
