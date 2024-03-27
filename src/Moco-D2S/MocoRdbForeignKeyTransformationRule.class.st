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
	tables := engine input
		selectElementsOfKind: MocoRdbTable
		notGuarded: #MocoRdbForeignKeyTransformationRule.
	
	tables do: [ :each |
		| statements |
		statements := self toAlterTableStatements: each.
		
		statements do: [ :st | engine addOutputElement: st withSource: each ].
		engine input guard: each with: #MocoRdbForeignKeyTransformationRule
	]
]

{ #category : #accessing }
MocoRdbForeignKeyTransformationRule >> priority [
	^ 99
]

{ #category : #'private - transforming' }
MocoRdbForeignKeyTransformationRule >> toAlterTable: aMocoRdbTable statementForKey: aMocoRdbForeignKey [
	"Returns an ALTER TABLE statement for the given foreign key."
	
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

{ #category : #'private - transforming' }
MocoRdbForeignKeyTransformationRule >> toAlterTableStatements: aMocoRdbTable [
	"Returns ALTER TABLE statements for foreign keys of the given table."
	
	^ (aMocoRdbTable constraints select: [ :each | each isKindOf: MocoRdbForeignKey ])
		collect: [ :each | self toAlterTable: aMocoRdbTable statementForKey: each ]
]
