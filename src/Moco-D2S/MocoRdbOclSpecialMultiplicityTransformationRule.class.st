"
Transforms special association multiplicity OCL constraint to CREATE TRIGGER statements in an Oracle relational database.
"
Class {
	#name : #MocoRdbOclSpecialMultiplicityTransformationRule,
	#superclass : #MocoTransformationRule,
	#category : #'Moco-D2S-Rule'
}

{ #category : #transforming }
MocoRdbOclSpecialMultiplicityTransformationRule >> execute [
	| ocls |
	ocls := engine input
		selectElementsOfKind: MocoOclRdbSpecialMultiplicityConstraint
		notGuarded: #MocoRdbOclSpecialMultiplicityTransformationRule.
	
	ocls do: [ :each |
		| triggers |
		triggers := OrderedCollection new.
		
		triggers
			add: (self generateTargetTrigger: each);
			add: (self generateSourceTrigger: each).
		
		triggers do: [ :e | engine addOutputElement: e withSource: each ].
		engine input guard: each with: #MocoRdbOclSpecialMultiplicityTransformationRule
	]
]

{ #category : #'private - processing' }
MocoRdbOclSpecialMultiplicityTransformationRule >> generateBetweenClause: aString forLower: aNumber andUpper: aNumber2 [
	| value |
	value := aString.
	
	(value anySatisfy: [ :each | each isSeparator ]) ifTrue: [ value := '(' , value , ')' ].
	
	aNumber ifNil: [ ^ value , ' <= ' , (aNumber2 asString) ].
	aNumber2 ifNil: [ ^ value , ' >= ' , (aNumber asString) ].
	^ value , ' BETWEEN ' , (aNumber asString) , ' AND ' , (aNumber2 asString)
]

{ #category : #'private - processing' }
MocoRdbOclSpecialMultiplicityTransformationRule >> generateSourceTrigger: aMocoOclRdbSpecialMultiplicityConstraint [
	| trigger events condition body varName varName2 |
	trigger := MocoSqlOracleCreateTrigger new.
	
	trigger name: ((aMocoOclRdbSpecialMultiplicityConstraint name) , '_REL');
		table: (aMocoOclRdbSpecialMultiplicityConstraint sourceTable name);
		time: #AFTER.
	
	events := OrderedCollection new.
	(aMocoOclRdbSpecialMultiplicityConstraint upper) ifNotNil: [ events add: 'INSERT' ].
	events add: 'UPDATE'.
	(aMocoOclRdbSpecialMultiplicityConstraint lower) ifNotNil: [ events add: 'DELETE' ].
	
	trigger event: (' OR ' join: events).
	
	body := String new writeStream.
	condition := String new writeStream.
	
	varName := MocoNamingUtils toShortName: (aMocoOclRdbSpecialMultiplicityConstraint context name).
	varName2 := MocoNamingUtils toShortName: (aMocoOclRdbSpecialMultiplicityConstraint sourceTable name).
	varName2 := MocoUniqueNameGenerator at: [ :each | each = varName ] seed: varName2.
	varName := MocoSqlOracleEscaping escapeName: varName.
	varName2 := MocoSqlOracleEscaping escapeName: varName2.
	
	condition
		nextPutAll: 'SELECT COUNT(*) FROM ';
		nextPutAll: (MocoSqlOracleEscaping escapeName: (aMocoOclRdbSpecialMultiplicityConstraint sourceTable name));
		nextPutAll: ' ';
		nextPutAll: varName2;
		nextPutAll: ' WHERE ';
		nextPutAll: varName2;
		nextPutAll: '.';
		nextPutAll: (MocoSqlOracleEscaping escapeName: (aMocoOclRdbSpecialMultiplicityConstraint sourceColumn name));
		nextPutAll: ' = ';
		nextPutAll: varName;
		nextPutAll: '.';
		nextPutAll: (MocoSqlOracleEscaping escapeName: (aMocoOclRdbSpecialMultiplicityConstraint targetColumn name)).
		
	
	body
		nextPutAll: 'DECLARE';
		cr;
		nextPutAll: '  "l_count" NUMBER := 0;';
		cr;
		nextPutAll: 'BEGIN';
		cr;
		nextPutAll: '  SELECT COUNT(1) INTO "l_count" FROM ';
		nextPutAll: (MocoSqlOracleEscaping escapeName: (aMocoOclRdbSpecialMultiplicityConstraint context name));
		nextPutAll: ' ';
		nextPutAll: varName;
		nextPutAll: ' WHERE NOT (';
		cr;
		nextPutAll: '    ';
		nextPutAll: (self generateBetweenClause: (condition contents) forLower: (aMocoOclRdbSpecialMultiplicityConstraint lower) andUpper: (aMocoOclRdbSpecialMultiplicityConstraint upper));
		nextPutAll: ');';
		cr;
		nextPutAll: '  IF "l_count" > 0 THEN';
		cr;
		nextPutAll: '    raise_application_error(-20101, ';
		nextPutAll: (MocoSqlOracleEscaping escapeLiteral: ('OCL constraint ' , (aMocoOclRdbSpecialMultiplicityConstraint name) , ' violated!'));
		nextPutAll: ');';
		cr;
		nextPutAll: '  END IF;';
		cr;
		nextPutAll: 'END;'.
	
	trigger body: (body contents).
	
	^ trigger
]

{ #category : #'private - processing' }
MocoRdbOclSpecialMultiplicityTransformationRule >> generateTargetTrigger: aMocoOclRdbSpecialMultiplicityConstraint [
	| trigger body varName |
	trigger := MocoSqlOracleCreateTrigger new.
	
	trigger name: (aMocoOclRdbSpecialMultiplicityConstraint name);
		table: (aMocoOclRdbSpecialMultiplicityConstraint context name);
		time: #BEFORE;
		event: #'INSERT OR UPDATE';
		granularity: #'EACH ROW'.
	
	body := String new writeStream.
	
	varName := MocoSqlOracleEscaping escapeName: (MocoNamingUtils toShortName: (aMocoOclRdbSpecialMultiplicityConstraint sourceTable name)).
	
	body
		nextPutAll: 'DECLARE';
		cr;
		nextPutAll: '  "l_count" NUMBER := 0;';
		cr;
		nextPutAll: 'BEGIN';
		cr;
		nextPutAll: '  SELECT COUNT(*) INTO "l_count" FROM ';
		nextPutAll: (MocoSqlOracleEscaping escapeName: (aMocoOclRdbSpecialMultiplicityConstraint sourceTable name));
		nextPutAll: ' ';
		nextPutAll: varName;
		nextPutAll: ' WHERE ';
		nextPutAll: varName;
		nextPutAll: '.';
		nextPutAll: (MocoSqlOracleEscaping escapeName: (aMocoOclRdbSpecialMultiplicityConstraint sourceColumn name));
		nextPutAll: ' = :new.';
		nextPutAll: (MocoSqlOracleEscaping escapeName: (aMocoOclRdbSpecialMultiplicityConstraint targetColumn name));
		nextPutAll: ';';
		cr;
		nextPutAll: '  IF NOT (';
		nextPutAll: (self generateBetweenClause: '"l_count"' forLower: (aMocoOclRdbSpecialMultiplicityConstraint lower) andUpper: (aMocoOclRdbSpecialMultiplicityConstraint upper));
		nextPutAll: ') THEN';
		cr;
		nextPutAll: '    raise_application_error(-20101, ';
		nextPutAll: (MocoSqlOracleEscaping escapeLiteral: ('OCL constraint ' , (aMocoOclRdbSpecialMultiplicityConstraint name) , ' violated!'));
		nextPutAll: ');';
		cr;
		nextPutAll: '  END IF;';
		cr;
		nextPutAll: 'END;'.
	
	trigger body: (body contents).
	
	^ trigger
]
