"
Transforms foreign key definitions to ALTER TABLE statements for an Oracle relational database.
"
Class {
	#name : 'MocoRdbOracleForeignKeyTransformationRule',
	#superclass : 'MocoTransformationRule',
	#category : 'Moco-D2SOracle-Rule',
	#package : 'Moco-D2SOracle',
	#tag : 'Rule'
}

{ #category : 'transforming' }
MocoRdbOracleForeignKeyTransformationRule >> execute [
	| tables |
	tables := engine input
		selectElementsOfKind: MocoRdbTable
		notGuarded: #MocoRdbOracleForeignKeyTransformationRule.
	
	tables do: [ :each |
		| statements |
		statements := self toAlterTableStatements: each.
		
		statements do: [ :st | engine addOutputElement: st withSource: each ].
		engine input guard: each with: #MocoRdbOracleForeignKeyTransformationRule
	]
]

{ #category : 'accessing' }
MocoRdbOracleForeignKeyTransformationRule >> priority [
	^ 99
]

{ #category : 'private - transforming' }
MocoRdbOracleForeignKeyTransformationRule >> toAlterTable: aMocoRdbTable statementForKey: aMocoRdbForeignKey [
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

{ #category : 'private - transforming' }
MocoRdbOracleForeignKeyTransformationRule >> toAlterTableStatements: aMocoRdbTable [
	"Returns ALTER TABLE statements for foreign keys of the given table."
	
	^ (aMocoRdbTable constraints select: [ :each | each isKindOf: MocoRdbForeignKey ])
		collect: [ :each | self toAlterTable: aMocoRdbTable statementForKey: each ]
]
