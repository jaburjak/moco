"
Transforms foreign key definitions to ALTER TABLE statements for a Microsoft SQL Server database.
"
Class {
	#name : 'MocoRdbMssqlForeignKeyTransformationRule',
	#superclass : 'MocoTransformationRule',
	#category : 'Moco-D2SMssql-Rule',
	#package : 'Moco-D2SMssql',
	#tag : 'Rule'
}

{ #category : 'transforming' }
MocoRdbMssqlForeignKeyTransformationRule >> execute [
	| tables |
	tables := engine input
		selectElementsOfKind: MocoRdbTable
		notGuarded: #MocoRdbMssqlForeignKeyTransformationRule.
	
	tables do: [ :each |
		| statements |
		statements := self toAlterTableStatements: each.
		
		statements do: [ :st | engine addOutputElement: st withSource: each ].
		engine input guard: each with: #MocoRdbMssqlForeignKeyTransformationRule
	]
]

{ #category : 'accessing' }
MocoRdbMssqlForeignKeyTransformationRule >> priority [
	^ 99
]

{ #category : 'private - transforming' }
MocoRdbMssqlForeignKeyTransformationRule >> toAlterTable: aMocoRdbTable statementForKey: aMocoRdbForeignKey [
	"Returns an ALTER TABLE statement for the given foreign key."
	
	| stmt body |
	stmt := MocoSqlMssqlAlterTable new.
	
	body := String new writeStream.
	
	body
		nextPutAll: 'ADD CONSTRAINT ';
		nextPutAll: (MocoSqlMssqlEscaping escapeName: (aMocoRdbForeignKey name));
		nextPutAll: ' FOREIGN KEY (';
		nextPutAll: (', ' join: (aMocoRdbForeignKey columns collect: [ :each | MocoSqlMssqlEscaping escapeName: (each name) ]));
		nextPutAll: ') REFERENCES ';
		nextPutAll: (MocoSqlMssqlEscaping escapeName: (aMocoRdbForeignKey referencedTable name));
		nextPutAll: ' (';
		nextPutAll: (', ' join: (aMocoRdbForeignKey referencedColumns collect: [ :each | MocoSqlMssqlEscaping escapeName: (each name) ]));
		nextPutAll: ')'.
	
	stmt table: (aMocoRdbTable name);
		statement: (body contents).
	
	^ stmt
]

{ #category : 'private - transforming' }
MocoRdbMssqlForeignKeyTransformationRule >> toAlterTableStatements: aMocoRdbTable [
	"Returns ALTER TABLE statements for foreign keys of the given table."
	
	^ (aMocoRdbTable constraints select: [ :each | each isKindOf: MocoRdbForeignKey ])
		collect: [ :each | self toAlterTable: aMocoRdbTable statementForKey: each ]
]
