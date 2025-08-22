"
Transforms special association multiplicity OCL constraint to CREATE TRIGGER statements.
"
Class {
	#name : 'MocoRdbMssqlOclSpecialMultiplicityTransformationRule',
	#superclass : 'MocoTransformationRule',
	#category : 'Moco-D2SMssql-Rule',
	#package : 'Moco-D2SMssql',
	#tag : 'Rule'
}

{ #category : 'transforming' }
MocoRdbMssqlOclSpecialMultiplicityTransformationRule >> execute [
	| ocls |
	ocls := engine input
		selectElementsOfKind: MocoOclRdbSpecialMultiplicityConstraint
		notGuarded: #MocoRdbMssqlOclSpecialMultiplicityTransformationRule.
	
	ocls do: [ :each |
		| triggers |
		triggers := OrderedCollection new.
		
		triggers
			add: (self generateTargetTrigger: each);
			add: (self generateSourceTrigger: each).
		
		triggers do: [ :e | engine addOutputElement: e withSource: each ].
		engine input guard: each with: #MocoRdbMssqlOclSpecialMultiplicityTransformationRule
	]
]

{ #category : 'private - processing' }
MocoRdbMssqlOclSpecialMultiplicityTransformationRule >> generateBetweenClause: aString forLower: aNumber andUpper: aNumber2 [
	| value |
	value := aString.
	
	(value anySatisfy: [ :each | each isSeparator ]) ifTrue: [ value := '(' , value , ')' ].
	
	aNumber ifNil: [ ^ value , ' <= ' , (aNumber2 asString) ].
	aNumber2 ifNil: [ ^ value , ' >= ' , (aNumber asString) ].
	(aNumber = aNumber2) ifTrue: [ ^ value , ' = ' , (aNumber asString) ].
	^ value , ' BETWEEN ' , (aNumber asString) , ' AND ' , (aNumber2 asString)
]

{ #category : 'private - processing' }
MocoRdbMssqlOclSpecialMultiplicityTransformationRule >> generateSourceTrigger: aMocoOclRdbSpecialMultiplicityConstraint [
	| trigger events condition body varName varName2 |
	trigger := MocoSqlMssqlCreateTrigger new.
	
	trigger name: ((MocoNamingUtils toUpperSnakeCase: (aMocoOclRdbSpecialMultiplicityConstraint name)) , '_REL');
		table: (aMocoOclRdbSpecialMultiplicityConstraint sourceTable name).
	
	events := OrderedCollection new.
	(aMocoOclRdbSpecialMultiplicityConstraint upper) ifNotNil: [ events add: 'INSERT' ].
	events add: 'UPDATE'.
	(aMocoOclRdbSpecialMultiplicityConstraint lower) ifNotNil: [ events add: 'DELETE' ].
	
	trigger event: (', ' join: events).
	
	body := String new writeStream.
	condition := String new writeStream.
	
	varName := MocoNamingUtils toShortName: (aMocoOclRdbSpecialMultiplicityConstraint context name).
	varName2 := MocoNamingUtils toShortName: (aMocoOclRdbSpecialMultiplicityConstraint sourceTable name).
	varName2 := MocoUniqueNameGenerator at: [ :each | each = varName ] seed: varName2.
	varName := MocoSqlMssqlEscaping escapeName: varName.
	varName2 := MocoSqlMssqlEscaping escapeName: varName2.
	
	condition
		nextPutAll: 'SELECT COUNT(1) FROM ';
		nextPutAll: (MocoSqlMssqlEscaping escapeName: (aMocoOclRdbSpecialMultiplicityConstraint sourceTable name));
		nextPutAll: ' ';
		nextPutAll: varName2;
		nextPutAll: ' WHERE ';
		nextPutAll: varName2;
		nextPutAll: '.';
		nextPutAll: (MocoSqlMssqlEscaping escapeName: (aMocoOclRdbSpecialMultiplicityConstraint sourceColumn name));
		nextPutAll: ' = ';
		nextPutAll: varName;
		nextPutAll: '.';
		nextPutAll: (MocoSqlMssqlEscaping escapeName: (aMocoOclRdbSpecialMultiplicityConstraint targetColumn name)).
	
	body
		nextPutAll: 'IF EXISTS (';
		cr;
		nextPutAll: '  SELECT 1 FROM ';
		nextPutAll: (MocoSqlMssqlEscaping escapeName: (aMocoOclRdbSpecialMultiplicityConstraint context name));
		nextPutAll: ' ';
		nextPutAll: varName;
		nextPutAll: ' WHERE NOT (';
		cr;
		nextPutAll: '    ';
		nextPutAll: (self generateBetweenClause: (condition contents) forLower: (aMocoOclRdbSpecialMultiplicityConstraint lower) andUpper: (aMocoOclRdbSpecialMultiplicityConstraint upper));
		cr;
		nextPutAll: ')) BEGIN';
		cr;
		nextPutAll: '  THROW 5000, ';
		nextPutAll: (MocoSqlMssqlEscaping escapeLiteral: ('OCL constraint ' , (aMocoOclRdbSpecialMultiplicityConstraint name) , ' violated!'));
		nextPutAll: ', 2;';
		cr;
		nextPutAll: 'END;'.
	
	trigger body: (body contents).
	
	^ trigger
]

{ #category : 'private - processing' }
MocoRdbMssqlOclSpecialMultiplicityTransformationRule >> generateTargetTrigger: aMocoOclRdbSpecialMultiplicityConstraint [
	| trigger body varName condition |
	trigger := MocoSqlMssqlCreateTrigger new.
	
	trigger name: (MocoNamingUtils toUpperSnakeCase: (aMocoOclRdbSpecialMultiplicityConstraint name));
		table: (aMocoOclRdbSpecialMultiplicityConstraint context name);
		event: #'INSERT, UPDATE'.
	
	varName := MocoNamingUtils toShortName: (aMocoOclRdbSpecialMultiplicityConstraint sourceTable name).
	varName := MocoUniqueNameGenerator at: [ :n | n = 'i' ] seed: varName.
	varName := MocoSqlMssqlEscaping escapeName: varName.
	
	condition := String new writeStream.
	
	condition
		nextPutAll: 'SELECT COUNT(1) FROM ';
		nextPutAll: (MocoSqlMssqlEscaping escapeName: (aMocoOclRdbSpecialMultiplicityConstraint sourceTable name));
		nextPutAll: ' ';
		nextPutAll: varName;
		nextPutAll: ' WHERE ';
		nextPutAll: varName;
		nextPutAll: '.';
		nextPutAll: (MocoSqlMssqlEscaping escapeName: (aMocoOclRdbSpecialMultiplicityConstraint sourceColumn name));
		nextPutAll: ' = [i].';
		nextPutAll: (MocoSqlMssqlEscaping escapeName: (aMocoOclRdbSpecialMultiplicityConstraint targetColumn name)).
	
	body := String new writeStream.
	
	body
		nextPutAll: 'IF EXISTS (';
		cr;
		nextPutAll: '  SELECT 1 FROM [inserted] [i] WHERE NOT (';
		cr;
		nextPutAll: '    ';
		nextPutAll: (self generateBetweenClause: (condition contents) forLower: (aMocoOclRdbSpecialMultiplicityConstraint lower) andUpper: (aMocoOclRdbSpecialMultiplicityConstraint upper));
		cr;
		nextPutAll: ')) BEGIN';
		cr;
		nextPutAll: '  THROW 5000, ';
		nextPutAll: (MocoSqlMssqlEscaping escapeLiteral: ('OCL constraint ' , (aMocoOclRdbSpecialMultiplicityConstraint name) , ' violated!'));
		nextPutAll: ', 1;';
		cr;
		nextPutAll: 'END;'.
	
	trigger body: (body contents).
	
	^ trigger
]
