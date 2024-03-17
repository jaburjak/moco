"
Represents an OCL invariant for exclusive phase associations after transforming them to a relational database model.
"
Class {
	#name : #MocoOclRdbExclusiveAssociationCondition,
	#superclass : #MocoOclInvariant,
	#instVars : [
		'column',
		'referencingTables',
		'referencingColumns'
	],
	#category : #'Moco-Ocl-Model'
}

{ #category : #accessing }
MocoOclRdbExclusiveAssociationCondition >> column [
	^ column
]

{ #category : #accessing }
MocoOclRdbExclusiveAssociationCondition >> column: aMocoRdbColumn [
	column := aMocoRdbColumn
]

{ #category : #'private - processing' }
MocoOclRdbExclusiveAssociationCondition >> generateAssociationVariableName: aMocoRdbTable [
	^ (MocoNamingUtils toPascalCase: ((aMocoRdbTable name asLowercase) copyReplaceAll: '_' with: ' ')) , '_Instance'
]

{ #category : #initialization }
MocoOclRdbExclusiveAssociationCondition >> initialize [
	super initialize.
	
	referencingTables := OrderedCollection new.
	referencingColumns := OrderedCollection new
]

{ #category : #printing }
MocoOclRdbExclusiveAssociationCondition >> printAssociation: aMocoRdbTable withColumn: aMocoRdbColumn to: aStream [
	| varName |
	varName := aMocoRdbTable name first asString asLowercase.
	
	aStream
		nextPutAll: '| def ';
		nextPutAll: (self generateAssociationVariableName: aMocoRdbTable);
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
		nextPutAll: (column name);
		nextPutAll: ')'
]

{ #category : #printing }
MocoOclRdbExclusiveAssociationCondition >> printTo: aStream [
	super printTo: aStream.
	
	referencingTables with: referencingColumns do: [ :t :c |
		self printAssociation: t withColumn: c to: aStream.
		aStream cr
	].

	aStream
		nextPutAll: '| ';
		nextPutAll: (' XOR ' join: (referencingTables collect: [ :each | self generateAssociationVariableName: each ]));
		cr;
		nextPutAll: '+----------------'
]

{ #category : #accessing }
MocoOclRdbExclusiveAssociationCondition >> referencingColumns [
	^ referencingColumns
]

{ #category : #accessing }
MocoOclRdbExclusiveAssociationCondition >> referencingTables [
	^ referencingTables
]
