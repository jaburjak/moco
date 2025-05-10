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
MocoOclRdbExclusiveAssociationCondition >> generateAssociationVariableName: aCollection [
	^ (MocoNamingUtils toPascalCase: ((' ' join: (aCollection collect: [ :e | e name asLowercase])) copyReplaceAll: '_' with: ' ')) , '_Instance'
]

{ #category : #'private - processing' }
MocoOclRdbExclusiveAssociationCondition >> generateExistsClause: aMocoRdbTable withColumn: aMocoRdbColumn [
	| varName stream |
	varName := MocoNamingUtils toShortName: (aMocoRdbTable name).
	
	stream := String new writeStream.
	
	stream
		nextPutAll: (aMocoRdbTable name);
		nextPutAll: '.allInstances()->exists(';
		nextPutAll: varName;
		nextPutAll: ' | ';
		nextPutAll: varName;
		nextPutAll: '.';
		nextPutAll: (aMocoRdbColumn name);
		nextPutAll: ' = self.';
		nextPutAll: (column name);
		nextPutAll: ')'.
	
	^ stream contents
]

{ #category : #initialization }
MocoOclRdbExclusiveAssociationCondition >> initialize [
	super initialize.
	
	referencingTables := OrderedCollection new.
	referencingColumns := OrderedCollection new
]

{ #category : #printing }
MocoOclRdbExclusiveAssociationCondition >> printAssociations: aCollection withColumns: aCollection2 to: aStream [
	| varName |
	varName := MocoNamingUtils toShortName: ('_' join: (aCollection collect: [ :e | e name ])).
	
	aStream
		nextPutAll: 'def ';
		nextPutAll: (self generateAssociationVariableName: aCollection);
		nextPutAll: ': Boolean =';
		cr;
		nextPutAll: '  ';
		nextPutAll: (' AND ' join: ((aCollection with: aCollection2 collect: [ :t :c | self generateExistsClause: t withColumn: c ])))
]

{ #category : #printing }
MocoOclRdbExclusiveAssociationCondition >> printOclTo: aStream [
	super printOclTo: aStream.
	
	referencingTables with: referencingColumns do: [ :t :c |
		self printAssociations: t withColumns: c to: aStream.
		aStream cr
	].

	aStream
		nextPutAll: (' XOR ' join: (referencingTables collect: [ :each | self generateAssociationVariableName: each ]))
]

{ #category : #accessing }
MocoOclRdbExclusiveAssociationCondition >> referencingColumns [
	^ referencingColumns
]

{ #category : #accessing }
MocoOclRdbExclusiveAssociationCondition >> referencingTables [
	^ referencingTables
]
