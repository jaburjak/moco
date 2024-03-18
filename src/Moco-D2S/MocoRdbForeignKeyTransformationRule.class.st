"
Transforms foreign key definitions to ALTER TABLE statements for an Oracle relational database.
"
Class {
	#name : #MocoRdbForeignKeyTransformationRule,
	#superclass : #MocoTransformationRule,
	#category : #'Moco-D2S-Rule'
}

{ #category : #transforming }
MocoRdbForeignKeyTransformationRule >> execute [
	| tables |
	tables := (engine inModel elements select: [ :e | e isWrappingType: MocoRdbTable ]) select: [ :e | e meta isNotProcessedBy: #MocoRdbForeignKeyTransformationRule ].
	
	tables do: [ :each |
		| statements |
		statements := self toAlterTableStatements: (each innerElement).
		statements := statements collect: [ :e | MocoWrappedElement from: e ].
		
		engine outModel elements addAll: statements.
		
		each meta outElements addAll: statements.
		each meta markProcessedBy: #MocoRdbForeignKeyTransformationRule.
	].

	tables ifNotEmpty: [ engine outModel meta didChange: true ]
]

{ #category : #accessing }
MocoRdbForeignKeyTransformationRule >> priority [
	^ 99
]

{ #category : #'private - processing' }
MocoRdbForeignKeyTransformationRule >> toAlterTable: aMocoRdbTable statementForKey: aMocoRdbForeignKey [
	| stmt body |
	stmt := MocoSqlOracleAlterTable new.
	
	body := String new writeStream.
	
	body
		nextPutAll: 'ADD CONSTRAINT ';
		nextPutAll: (MocoSqlOracleEscaping escapeName: (aMocoRdbForeignKey name));
		nextPutAll: ' FOREIGN KEY (';
		nextPutAll: (', ' join: (aMocoRdbForeignKey columns collect: [ :each | MocoSqlOracleEscaping escapeName: (each name) ]));
		nextPutAll: ') REFERENCES ';
		nextPutAll: (MocoSqlOracleEscaping escapeName: (aMocoRdbForeignKey referencedTable name));
		nextPutAll: ' (';
		nextPutAll: (', ' join: (aMocoRdbForeignKey referencedColumns collect: [ :each | MocoSqlOracleEscaping escapeName: (each name) ]));
		nextPutAll: ') DEFERRABLE INITIALLY DEFERRED'.
	
	stmt table: (aMocoRdbTable name);
		statement: (body contents).
	
	^ stmt
]

{ #category : #'private - processing' }
MocoRdbForeignKeyTransformationRule >> toAlterTableStatements: aMocoRdbTable [
	^ (aMocoRdbTable constraints select: [ :each | each isKindOf: MocoRdbForeignKey ])
		collect: [ :each | self toAlterTable: aMocoRdbTable statementForKey: each ]
]
