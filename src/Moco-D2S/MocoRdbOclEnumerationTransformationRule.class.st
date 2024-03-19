"
Transforms OCL enumeration constraints to CHECK constraints.
"
Class {
	#name : #MocoRdbOclEnumerationTransformationRule,
	#superclass : #MocoTransformationRule,
	#category : #'Moco-D2S-Rule'
}

{ #category : #transforming }
MocoRdbOclEnumerationTransformationRule >> execute [
	| ocls |
	ocls := engine inModel elements select: [ :each | (each isWrappingType: MocoOclRdbEnumerationConstraint) and: [ each meta isNotProcessedBy: #MocoRdbOclEnumerationTransformationRule ] ].
	
	ocls do: [ :each |
		| statement |
		statement := self generateCheck: (each innerElement).
		statement := MocoWrappedElement from: statement.
		
		each meta outElements add: statement.
		engine outModel elements add: statement.
		
		each meta markProcessedBy: #MocoRdbOclEnumerationTransformationRule
	].

	ocls ifNotEmpty: [ engine outModel meta didChange: true ]
]

{ #category : #'private - transforming' }
MocoRdbOclEnumerationTransformationRule >> generateCheck: aMocoOclRdbEnumerationConstraint [
	| body column stmt |
	body := String new writeStream.
	
	column := MocoSqlOracleEscaping escapeName: (aMocoOclRdbEnumerationConstraint column name).
	
	body
		nextPutAll: 'ADD CONSTRAINT ';
		nextPutAll: (MocoSqlOracleEscaping escapeName: ('EN_' , (aMocoOclRdbEnumerationConstraint context name) , '_' , (aMocoOclRdbEnumerationConstraint column name)));
		nextPutAll: ' CHECK (';
		nextPutAll: (' OR ' join: (aMocoOclRdbEnumerationConstraint values collect: [ :each | column , ' = ' , (MocoSqlOracleEscaping escapeLiteral: each) ]));
		nextPutAll: ')'.
	
	stmt := MocoSqlOracleAlterTable new.
	stmt table: (aMocoOclRdbEnumerationConstraint context name);
		statement: (body contents).
	
	^ stmt
]

{ #category : #accessing }
MocoRdbOclEnumerationTransformationRule >> priority [
	^ 80
]
