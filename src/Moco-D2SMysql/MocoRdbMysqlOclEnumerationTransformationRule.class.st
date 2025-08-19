"
Transforms OCL enumeration constraints to CHECK constraints.
"
Class {
	#name : 'MocoRdbMysqlOclEnumerationTransformationRule',
	#superclass : 'MocoTransformationRule',
	#category : 'Moco-D2SMysql-Rule',
	#package : 'Moco-D2SMysql',
	#tag : 'Rule'
}

{ #category : 'transforming' }
MocoRdbMysqlOclEnumerationTransformationRule >> execute [
	| ocls |
	ocls := engine input
		selectElementsOfKind: MocoOclRdbEnumerationConstraint
		notGuarded: #MocoRdbMysqlOclEnumerationTransformationRule.
	
	ocls do: [ :each |
		| statement |
		statement := self generateCheck: each.
		
		engine addOutputElement: statement withSource: each.
		engine input guard: each with: #MocoRdbMysqlOclEnumerationTransformationRule
	]
]

{ #category : 'private - transforming' }
MocoRdbMysqlOclEnumerationTransformationRule >> generateCheck: aMocoOclRdbEnumerationConstraint [
	"Creates an ALTER TABLE statement with a CHECK for the given enumeration constraint."
	
	| body column stmt |
	body := String new writeStream.
	
	column := MocoSqlMysqlEscaping escapeName: (aMocoOclRdbEnumerationConstraint column name).
	
	body
		nextPutAll: 'ADD CONSTRAINT ';
		nextPutAll: (MocoSqlMysqlEscaping escapeName: ('EN_' , (aMocoOclRdbEnumerationConstraint context name) , '_' , (aMocoOclRdbEnumerationConstraint column name)));
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
	
	stmt := MocoSqlMysqlAlterTable new.
	stmt table: (aMocoOclRdbEnumerationConstraint context name);
		statement: (body contents).
	
	^ stmt
]

{ #category : 'accessing' }
MocoRdbMysqlOclEnumerationTransformationRule >> priority [
	^ 80
]
