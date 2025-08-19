"
Transforms foreign key definitions to ALTER TABLE statements for a PostgreSQL database.
"
Class {
	#name : 'MocoRdbPostgresqlForeignKeyTransformationRule',
	#superclass : 'MocoTransformationRule',
	#category : 'Moco-D2SPostgresql-Rule',
	#package : 'Moco-D2SPostgresql',
	#tag : 'Rule'
}

{ #category : 'transforming' }
MocoRdbPostgresqlForeignKeyTransformationRule >> execute [
	| tables |
	tables := engine input
		selectElementsOfKind: MocoRdbTable
		notGuarded: #MocoRdbPostgresqlForeignKeyTransformationRule.
	
	tables do: [ :each |
		| statements |
		statements := self toAlterTableStatements: each.
		
		statements do: [ :st | engine addOutputElement: st withSource: each ].
		engine input guard: each with: #MocoRdbPostgresqlForeignKeyTransformationRule
	]
]

{ #category : 'accessing' }
MocoRdbPostgresqlForeignKeyTransformationRule >> priority [
	^ 99
]

{ #category : 'private - transforming' }
MocoRdbPostgresqlForeignKeyTransformationRule >> toAlterTable: aMocoRdbTable statementForKey: aMocoRdbForeignKey [
	"Returns an ALTER TABLE statement for the given foreign key."
	
	| stmt body |
	stmt := MocoSqlPostgresqlAlterTable new.
	
	body := String new writeStream.
	
	body
		nextPutAll: 'ADD CONSTRAINT ';
		nextPutAll: (MocoSqlPostgresqlEscaping escapeName: (aMocoRdbForeignKey name));
		nextPutAll: ' FOREIGN KEY (';
		nextPutAll: (', ' join: (aMocoRdbForeignKey columns collect: [ :each | MocoSqlPostgresqlEscaping escapeName: (each name) ]));
		nextPutAll: ') REFERENCES ';
		nextPutAll: (MocoSqlPostgresqlEscaping escapeName: (aMocoRdbForeignKey referencedTable name));
		nextPutAll: ' (';
		nextPutAll: (', ' join: (aMocoRdbForeignKey referencedColumns collect: [ :each | MocoSqlPostgresqlEscaping escapeName: (each name) ]));
		nextPutAll: ') DEFERRABLE INITIALLY DEFERRED'.
	
	stmt table: (aMocoRdbTable name);
		statement: (body contents).
	
	^ stmt
]

{ #category : 'private - transforming' }
MocoRdbPostgresqlForeignKeyTransformationRule >> toAlterTableStatements: aMocoRdbTable [
	"Returns ALTER TABLE statements for foreign keys of the given table."
	
	^ (aMocoRdbTable constraints select: [ :each | each isKindOf: MocoRdbForeignKey ])
		collect: [ :each | self toAlterTable: aMocoRdbTable statementForKey: each ]
]
