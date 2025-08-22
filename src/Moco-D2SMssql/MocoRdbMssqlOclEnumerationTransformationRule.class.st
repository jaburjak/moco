"
Transforms OCL enumeration constraints to CHECK constraints.
"
Class {
	#name : 'MocoRdbMssqlOclEnumerationTransformationRule',
	#superclass : 'MocoTransformationRule',
	#category : 'Moco-D2SMssql-Rule',
	#package : 'Moco-D2SMssql',
	#tag : 'Rule'
}

{ #category : 'transforming' }
MocoRdbMssqlOclEnumerationTransformationRule >> execute [
	| ocls |
	ocls := engine input
		selectElementsOfKind: MocoOclRdbEnumerationConstraint
		notGuarded: #MocoRdbMssqlOclEnumerationTransformationRule.
	
	ocls do: [ :each |
		| statement |
		statement := self generateCheck: each.
		
		engine addOutputElement: statement withSource: each.
		engine input guard: each with: #MocoRdbMssqlOclEnumerationTransformationRule
	]
]

{ #category : 'private - transforming' }
MocoRdbMssqlOclEnumerationTransformationRule >> generateCheck: aMocoOclRdbEnumerationConstraint [
	"Creates an ALTER TABLE statement with a CHECK for the given enumeration constraint."
	
	| body column stmt |
	body := String new writeStream.
	
	column := MocoSqlMssqlEscaping escapeName: (aMocoOclRdbEnumerationConstraint column name).
	
	body
		nextPutAll: 'ADD CONSTRAINT ';
		nextPutAll: (MocoSqlMssqlEscaping escapeName: ('EN_' , (aMocoOclRdbEnumerationConstraint context name) , '_' , (aMocoOclRdbEnumerationConstraint column name)));
		nextPutAll: ' CHECK ('.
	
	(aMocoOclRdbEnumerationConstraint column nullable) ifTrue: [
		body
			nextPutAll: column;
			nextPutAll: ' IS NULL'.
		
		(aMocoOclRdbEnumerationConstraint values ifNotEmpty: [ body nextPutAll: ' OR ' ])
	].
	
	body
		nextPutAll: (' OR ' join: (aMocoOclRdbEnumerationConstraint values collect: [ :each | column , ' = ' , (MocoSqlMysqlEscaping escapeLiteral: each) ]));
		nextPutAll: ')'.
	
	stmt := MocoSqlMssqlAlterTable new.
	stmt table: (aMocoOclRdbEnumerationConstraint context name);
		statement: (body contents).
	
	^ stmt
]

{ #category : 'accessing' }
MocoRdbMssqlOclEnumerationTransformationRule >> priority [
	^ 80
]
