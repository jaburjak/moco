"
Transforms OCL enumeration constraints to CHECK constraints.
"
Class {
	#name : 'MocoRdbOracleOclEnumerationTransformationRule',
	#superclass : 'MocoTransformationRule',
	#category : 'Moco-D2SOracle-Rule',
	#package : 'Moco-D2SOracle',
	#tag : 'Rule'
}

{ #category : 'transforming' }
MocoRdbOracleOclEnumerationTransformationRule >> execute [
	| ocls |
	ocls := engine input
		selectElementsOfKind: MocoOclRdbEnumerationConstraint
		notGuarded: #MocoRdbOracleOclEnumerationTransformationRule.
	
	ocls do: [ :each |
		| statement |
		statement := self generateCheck: each.
		
		engine addOutputElement: statement withSource: each.
		engine input guard: each with: #MocoRdbOracleOclEnumerationTransformationRule
	]
]

{ #category : 'private - transforming' }
MocoRdbOracleOclEnumerationTransformationRule >> generateCheck: aMocoOclRdbEnumerationConstraint [
	"Creates an ALTER TABLE statement with a CHECK for the given enumeration constraint."
	
	| body column stmt |
	body := String new writeStream.
	
	column := MocoSqlOracleEscaping escapeName: (aMocoOclRdbEnumerationConstraint column name).
	
	body
		nextPutAll: 'ADD CONSTRAINT ';
		nextPutAll: (MocoSqlOracleEscaping escapeName: ('EN_' , (aMocoOclRdbEnumerationConstraint context name) , '_' , (aMocoOclRdbEnumerationConstraint column name)));
		nextPutAll: ' CHECK ('.
	
	(aMocoOclRdbEnumerationConstraint column nullable) ifTrue: [
		body
			nextPutAll: column;
			nextPutAll: ' IS NULL'.
		
		(aMocoOclRdbEnumerationConstraint values ifNotEmpty: [ body nextPutAll: ' OR ' ])
	].
	
	body
		nextPutAll: (' OR ' join: (aMocoOclRdbEnumerationConstraint values collect: [ :each | column , ' = ' , (MocoSqlOracleEscaping escapeLiteral: each) ]));
		nextPutAll: ')'.
	
	stmt := MocoSqlOracleAlterTable new.
	stmt table: (aMocoOclRdbEnumerationConstraint context name);
		statement: (body contents).
	
	^ stmt
]

{ #category : 'accessing' }
MocoRdbOracleOclEnumerationTransformationRule >> priority [
	^ 80
]
