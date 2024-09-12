"
Transforms OCL enumeration constraints to CHECK constraints.
"
Class {
	#name : #MocoRdbPostgresqlOclEnumerationTransformationRule,
	#superclass : #MocoTransformationRule,
	#category : #'Moco-D2SPostgresql-Rule'
}

{ #category : #transforming }
MocoRdbPostgresqlOclEnumerationTransformationRule >> execute [
	| ocls |
	ocls := engine input
		selectElementsOfKind: MocoOclRdbEnumerationConstraint
		notGuarded: #MocoRdbPostgresqlOclEnumerationTransformationRule.
	
	ocls do: [ :each |
		| statement |
		statement := self generateCheck: each.
		
		engine addOutputElement: statement withSource: each.
		engine input guard: each with: #MocoRdbPostgresqlOclEnumerationTransformationRule
	]
]

{ #category : #'private - transforming' }
MocoRdbPostgresqlOclEnumerationTransformationRule >> generateCheck: aMocoOclRdbEnumerationConstraint [
	"Creates an ALTER TABLE statement with a CHECK for the given enumeration constraint."
	
	| body column stmt |
	body := String new writeStream.
	
	column := MocoSqlPostgresqlEscaping escapeName: (aMocoOclRdbEnumerationConstraint column name).
	
	body
		nextPutAll: 'ADD CONSTRAINT ';
		nextPutAll: (MocoSqlPostgresqlEscaping escapeName: ('EN_' , (aMocoOclRdbEnumerationConstraint context name) , '_' , (aMocoOclRdbEnumerationConstraint column name)));
		nextPutAll: ' CHECK ('.
	
	(aMocoOclRdbEnumerationConstraint column nullable) ifTrue: [
		body
			nextPutAll: column;
			nextPutAll: ' IS NULL'.
		
		(aMocoOclRdbEnumerationConstraint values ifNotEmpty: [ body nextPutAll: ' OR ' ])
	].
	
	body
		nextPutAll: (' OR ' join: (aMocoOclRdbEnumerationConstraint values collect: [ :each | column , ' = ' , (MocoSqlPostgresqlEscaping escapeLiteral: each) ]));
		nextPutAll: ')'.
	
	stmt := MocoSqlPostgresqlAlterTable new.
	stmt table: (aMocoOclRdbEnumerationConstraint context name);
		statement: (body contents).
	
	^ stmt
]

{ #category : #accessing }
MocoRdbPostgresqlOclEnumerationTransformationRule >> priority [
	^ 80
]
