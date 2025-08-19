"
Transforms OCL enumeration constraints to CHECK constraints.
"
Class {
	#name : 'MocoRdbOclEnumerationTransformationRule',
	#superclass : 'MocoTransformationRule',
	#category : 'Moco-D2S-Rule',
	#package : 'Moco-D2S',
	#tag : 'Rule'
}

{ #category : 'transforming' }
MocoRdbOclEnumerationTransformationRule >> execute [
	| ocls |
	ocls := engine input
		selectElementsOfKind: MocoOclRdbEnumerationConstraint
		notGuarded: #MocoRdbOclEnumerationTransformationRule.
	
	ocls do: [ :each |
		| statement |
		statement := self generateCheck: each.
		
		engine addOutputElement: statement withSource: each.
		engine input guard: each with: #MocoRdbOclEnumerationTransformationRule
	]
]

{ #category : 'private - transforming' }
MocoRdbOclEnumerationTransformationRule >> generateCheck: aMocoOclRdbEnumerationConstraint [
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
MocoRdbOclEnumerationTransformationRule >> priority [
	^ 80
]
