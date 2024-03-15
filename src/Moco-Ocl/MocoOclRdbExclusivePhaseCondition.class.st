"
Represents an OCL invariant for exclusive phase associations after transforming them to a relational database model.
"
Class {
	#name : #MocoOclRdbExclusivePhaseCondition,
	#superclass : #MocoOclInvariant,
	#instVars : [
		'phaseTables',
		'phaseColumns',
		'generalColumn'
	],
	#category : #'Moco-Ocl-Model'
}

{ #category : #accessing }
MocoOclRdbExclusivePhaseCondition >> generalColumn [
	^ generalColumn
]

{ #category : #accessing }
MocoOclRdbExclusivePhaseCondition >> generalColumn: aMocoRdbColumn [
	generalColumn := aMocoRdbColumn
]

{ #category : #'private - processing' }
MocoOclRdbExclusivePhaseCondition >> generatePhaseVariableName: aMocoRdbTable [
	^ (MocoNamingUtils toPascalCase: ((aMocoRdbTable name asLowercase) copyReplaceAll: '_' with: ' ')) , '_Instance'
]

{ #category : #initialization }
MocoOclRdbExclusivePhaseCondition >> initialize [
	super initialize.
	
	phaseTables := OrderedCollection new.
	phaseColumns := OrderedCollection new
]

{ #category : #accessing }
MocoOclRdbExclusivePhaseCondition >> phaseColumns [
	^ phaseColumns
]

{ #category : #accessing }
MocoOclRdbExclusivePhaseCondition >> phaseTables [
	^ phaseTables
]

{ #category : #printing }
MocoOclRdbExclusivePhaseCondition >> printPhase: aMocoRdbTable withColumn: aMocoRdbColumn to: aStream [
	| varName |
	varName := aMocoRdbTable name first asString asLowercase.
	
	aStream
		nextPutAll: '| def ';
		nextPutAll: (self generatePhaseVariableName: aMocoRdbTable);
		nextPutAll: ': Boolean =';
		cr;
		nextPutAll: '|   ';
		nextPutAll: (aMocoRdbTable name);
		nextPutAll: '.allInstances()->exists(';
		nextPutAll: varName;
		nextPutAll: ' | ';
		nextPutAll: varName;
		nextPutAll: '.';
		nextPutAll: (aMocoRdbColumn name);
		nextPutAll: ' = self.';
		nextPutAll: (generalColumn name);
		nextPutAll: ')'
]

{ #category : #printing }
MocoOclRdbExclusivePhaseCondition >> printTo: aStream [
	super printTo: aStream.
	
	phaseTables with: phaseColumns do: [ :t :c |
		self printPhase: t withColumn: c to: aStream.
		aStream cr
	].

	aStream
		nextPutAll: '| ';
		nextPutAll: (' XOR ' join: (phaseTables collect: [ :each | self generatePhaseVariableName: each ]));
		cr;
		nextPutAll: '+----------------'
]
