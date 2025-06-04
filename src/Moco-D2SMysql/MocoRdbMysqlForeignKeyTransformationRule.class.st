"
Transforms foreign key definitions to ALTER TABLE statements for a MySQL database.
"
Class {
	#name : #MocoRdbMysqlForeignKeyTransformationRule,
	#superclass : #MocoTransformationRule,
	#category : #'Moco-D2SMysql-Rule'
}

{ #category : #transforming }
MocoRdbMysqlForeignKeyTransformationRule >> execute [
	| tables |
	tables := engine input
		selectElementsOfKind: MocoRdbTable
		notGuarded: #MocoRdbMysqlForeignKeyTransformationRule.
	
	tables do: [ :each |
		| statements |
		statements := self toAlterTableStatements: each.
		
		statements do: [ :st | engine addOutputElement: st withSource: each ].
		engine input guard: each with: #MocoRdbMysqlForeignKeyTransformationRule
	]
]

{ #category : #accessing }
MocoRdbMysqlForeignKeyTransformationRule >> priority [
	^ 99
]

{ #category : #'private - transforming' }
MocoRdbMysqlForeignKeyTransformationRule >> toAlterTable: aMocoRdbTable statementForKey: aMocoRdbForeignKey [
	"Returns an ALTER TABLE statement for the given foreign key."
	
	| stmt body |
	stmt := MocoSqlMysqlAlterTable new.
	
	body := String new writeStream.
	
	body
		nextPutAll: 'ADD CONSTRAINT ';
		nextPutAll: (MocoSqlMysqlEscaping escapeName: (aMocoRdbForeignKey name));
		nextPutAll: ' FOREIGN KEY (';
		nextPutAll: (', ' join: (aMocoRdbForeignKey columns collect: [ :each | MocoSqlMysqlEscaping escapeName: (each name) ]));
		nextPutAll: ') REFERENCES ';
		nextPutAll: (MocoSqlMysqlEscaping escapeName: (aMocoRdbForeignKey referencedTable name));
		nextPutAll: ' (';
		nextPutAll: (', ' join: (aMocoRdbForeignKey referencedColumns collect: [ :each | MocoSqlMysqlEscaping escapeName: (each name) ]));
		nextPutAll: ')'.
	
	stmt table: (aMocoRdbTable name);
		statement: (body contents).
	
	^ stmt
]

{ #category : #'private - transforming' }
MocoRdbMysqlForeignKeyTransformationRule >> toAlterTableStatements: aMocoRdbTable [
	"Returns ALTER TABLE statements for foreign keys of the given table."
	
	^ (aMocoRdbTable constraints select: [ :each | each isKindOf: MocoRdbForeignKey ])
		collect: [ :each | self toAlterTable: aMocoRdbTable statementForKey: each ]
]
