"
Transforms special association multiplicity OCL constraint to CREATE TRIGGER statements in a PostgreSQL database.
"
Class {
	#name : #MocoRdbPostgresqlOclSpecialMultiplicityTransformationRule,
	#superclass : #MocoTransformationRule,
	#category : #'Moco-D2SPostgresql-Rule'
}

{ #category : #transforming }
MocoRdbPostgresqlOclSpecialMultiplicityTransformationRule >> execute [
	| ocls |
	ocls := engine input
		selectElementsOfKind: MocoOclRdbSpecialMultiplicityConstraint
		notGuarded: #MocoRdbPostgresqlOclSpecialMultiplicityTransformationRule.
	
	ocls do: [ :each |
		| triggers |
		triggers := OrderedCollection new.
		
		triggers
			add: (self generateTargetTrigger: each);
			add: (self generateSourceTrigger: each).
		
		triggers do: [ :e | engine addOutputElement: e withSource: each ].
		engine input guard: each with: #MocoRdbPostgresqlOclSpecialMultiplicityTransformationRule
	]
]

{ #category : #'private - processing' }
MocoRdbPostgresqlOclSpecialMultiplicityTransformationRule >> generateBetweenClauseForLower: aNumber andUpper: aNumber2 [
	aNumber ifNil: [ ^ '<= ' , (aNumber2 asString) ].
	aNumber2 ifNil: [ ^ '>= ' , (aNumber asString) ].
	^ 'BETWEEN ' , (aNumber asString) , ' AND ' , (aNumber2 asString)
]

{ #category : #'private - processing' }
MocoRdbPostgresqlOclSpecialMultiplicityTransformationRule >> generateSourceTrigger: aMocoOclRdbSpecialMultiplicityConstraint [
	| trigger events condition body varName varName2 |
	trigger := MocoSqlPostgresqlCreateTrigger new.
	
	trigger name: ((MocoNamingUtils toUpperSnakeCase: (aMocoOclRdbSpecialMultiplicityConstraint name)) , '_REL');
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
	varName := MocoSqlPostgresqlEscaping escapeName: varName.
	varName2 := MocoSqlPostgresqlEscaping escapeName: varName2.
	
	body
		nextPutAll: 'IF EXISTS (';
		cr;
		nextPutAll: '  SELECT 1 FROM ';
		nextPutAll: (MocoSqlPostgresqlEscaping escapeName: (aMocoOclRdbSpecialMultiplicityConstraint context name));
		nextPutAll: ' ';
		nextPutAll: varName;
		nextPutAll: ' WHERE NOT (';
		cr;
		nextPutAll: '    SELECT COUNT(1) FROM ';
		nextPutAll: (MocoSqlPostgresqlEscaping escapeName: (aMocoOclRdbSpecialMultiplicityConstraint sourceTable name));
		nextPutAll: ' ';
		nextPutAll: varName2;
		nextPutAll: ' WHERE ';
		nextPutAll: varName2;
		nextPutAll: '.';
		nextPutAll: (MocoSqlPostgresqlEscaping escapeName: (aMocoOclRdbSpecialMultiplicityConstraint sourceColumn name));
		nextPutAll: ' = ';
		nextPutAll: varName;
		nextPutAll: '.';
		nextPutAll: (MocoSqlPostgresqlEscaping escapeName: (aMocoOclRdbSpecialMultiplicityConstraint targetColumn name));
		cr;
		nextPutAll: '  ) ';
		nextPutAll: (self generateBetweenClauseForLower: (aMocoOclRdbSpecialMultiplicityConstraint lower) andUpper: (aMocoOclRdbSpecialMultiplicityConstraint upper));
		cr;
		nextPutAll: ') THEN';
		cr;
		nextPutAll: '  RAISE EXCEPTION ';
		nextPutAll: (MocoSqlPostgresqlEscaping escapeLiteral: ('OCL constraint ' , (aMocoOclRdbSpecialMultiplicityConstraint name) , ' violated!'));
		nextPutAll: ';';
		cr;
		nextPutAll: 'END IF;';
		cr;
		nextPutAll: 'RETURN NULL;'.
	
	trigger body: (body contents).
	
	^ trigger
]

{ #category : #'private - processing' }
MocoRdbPostgresqlOclSpecialMultiplicityTransformationRule >> generateTargetTrigger: aMocoOclRdbSpecialMultiplicityConstraint [
	| trigger body varName |
	trigger := MocoSqlPostgresqlCreateTrigger new.
	
	trigger name: (MocoNamingUtils toUpperSnakeCase: (aMocoOclRdbSpecialMultiplicityConstraint name));
		table: (aMocoOclRdbSpecialMultiplicityConstraint context name);
		time: #BEFORE;
		event: #'INSERT OR UPDATE';
		granularity: #'EACH ROW'.
	
	body := String new writeStream.
	
	varName := MocoSqlPostgresqlEscaping escapeName: (MocoNamingUtils toShortName: (aMocoOclRdbSpecialMultiplicityConstraint sourceTable name)).
	
	body
		nextPutAll: 'IF NOT (';
		cr;
		nextPutAll: '  (SELECT COUNT(1) FROM ';
		nextPutAll: (MocoSqlPostgresqlEscaping escapeName: (aMocoOclRdbSpecialMultiplicityConstraint sourceTable name));
		nextPutAll: ' ';
		nextPutAll: varName;
		nextPutAll: ' WHERE ';
		nextPutAll: varName;
		nextPutAll: '.';
		nextPutAll: (MocoSqlPostgresqlEscaping escapeName: (aMocoOclRdbSpecialMultiplicityConstraint sourceColumn name));
		nextPutAll: ' = NEW.';
		nextPutAll: (MocoSqlPostgresqlEscaping escapeName: (aMocoOclRdbSpecialMultiplicityConstraint targetColumn name));
		nextPutAll: ')';
		cr;
		nextPutAll: '  ';
		nextPutAll: (self generateBetweenClauseForLower: (aMocoOclRdbSpecialMultiplicityConstraint lower) andUpper: (aMocoOclRdbSpecialMultiplicityConstraint upper));
		cr;
		nextPutAll: ') THEN';
		cr;
		nextPutAll: '  RAISE EXCEPTION ';
		nextPutAll: (MocoSqlPostgresqlEscaping escapeLiteral: ('OCL constraint ' , (aMocoOclRdbSpecialMultiplicityConstraint name) , ' violated!'));
		nextPutAll: ';';
		cr;
		nextPutAll: 'END IF;';
		cr;
		nextPutAll: 'RETURN NEW;'.
	
	trigger body: (body contents).
	
	^ trigger
]
