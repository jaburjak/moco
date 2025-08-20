"
Transforms mandatory association multiplicity OCL constraint to CREATE TRIGGER statements in an Oracle relational database.
"
Class {
	#name : 'MocoRdbOracleOclMandatoryMultiplicityTransformationRule',
	#superclass : 'MocoTransformationRule',
	#category : 'Moco-D2SOracle-Rule',
	#package : 'Moco-D2SOracle',
	#tag : 'Rule'
}

{ #category : 'transforming' }
MocoRdbOracleOclMandatoryMultiplicityTransformationRule >> execute [
	| ocls |
	ocls := engine input
		selectElementsOfKind: MocoOclRdbMandatoryMultiplicityConstraint
		notGuarded: #MocoRdbOracleOclMandatoryMultiplicityTransformationRule.
	
	ocls do: [ :each |
		| triggers |
		triggers := OrderedCollection new.
		
		triggers
			add: (self generateTargetTrigger: each);
			add: (self generateSourceTrigger: each).
		
		triggers do: [ :e | engine addOutputElement: e withSource: each ].
		engine input guard: each with: #MocoRdbOracleOclMandatoryMultiplicityTransformationRule
	]
]

{ #category : 'private - processing' }
MocoRdbOracleOclMandatoryMultiplicityTransformationRule >> generateSourceTrigger: aMocoOclRdbMandatoryMultiplicityConstraint [
	| trigger body varName varName2 |
	trigger := MocoSqlOracleCreateTrigger new.
	
	trigger name: ((MocoNamingUtils toUpperSnakeCase: (aMocoOclRdbMandatoryMultiplicityConstraint name)) , '_REL');
		table: (aMocoOclRdbMandatoryMultiplicityConstraint sourceTable name);
		time: #AFTER;
		event: #'UPDATE OR DELETE'.
	
	body := String new writeStream.
	
	varName := MocoSqlOracleEscaping escapeName: (MocoNamingUtils toShortName: (aMocoOclRdbMandatoryMultiplicityConstraint context name)).
	varName2 := MocoSqlOracleEscaping escapeName: (MocoNamingUtils toShortName: (aMocoOclRdbMandatoryMultiplicityConstraint sourceTable name)).
	
	body
		nextPutAll: 'DECLARE';
		cr;
		nextPutAll: '  "l_count" NUMBER := 0;';
		cr;
		nextPutAll: 'BEGIN';
		cr;
		nextPutAll: '  SELECT COUNT(1) INTO "l_count" FROM ';
		nextPutAll: (MocoSqlOracleEscaping escapeName: (aMocoOclRdbMandatoryMultiplicityConstraint context name));
		nextPutAll: ' ';
		nextPutAll: varName;
		nextPutAll: ' WHERE ';
		cr;
		nextPutAll: '    NOT EXISTS (SELECT 1 FROM ';
		nextPutAll: (MocoSqlOracleEscaping escapeName: (aMocoOclRdbMandatoryMultiplicityConstraint sourceTable name));
		nextPutAll: ' ';
		nextPutAll: varName2;
		nextPutAll: ' WHERE ';
		nextPutAll: varName2;
		nextPutAll: '.';
		nextPutAll: (MocoSqlOracleEscaping escapeName: (aMocoOclRdbMandatoryMultiplicityConstraint sourceColumn name));
		nextPutAll: ' = ';
		nextPutAll: varName;
		nextPutAll: '.';
		nextPutAll: (MocoSqlOracleEscaping escapeName: (aMocoOclRdbMandatoryMultiplicityConstraint targetColumn name));
		nextPutAll: ');';
		cr;
		nextPutAll: '  IF "l_count" > 0 THEN';
		cr;
		nextPutAll: '    raise_application_error(-20101, ';
		nextPutAll: (MocoSqlOracleEscaping escapeLiteral: ('OCL constraint ' , (aMocoOclRdbMandatoryMultiplicityConstraint name) , ' violated!'));
		nextPutAll: ');';
		cr;
		nextPutAll: '  END IF;';
		cr;
		nextPutAll: 'END;'.
	
	trigger body: (body contents).
	
	^ trigger
]

{ #category : 'private - processing' }
MocoRdbOracleOclMandatoryMultiplicityTransformationRule >> generateTargetTrigger: aMocoOclRdbMandatoryMultiplicityConstraint [
	| trigger body varName |
	trigger := MocoSqlOracleCreateTrigger new.
	
	trigger name: (MocoNamingUtils toUpperSnakeCase: (aMocoOclRdbMandatoryMultiplicityConstraint name));
		table: (aMocoOclRdbMandatoryMultiplicityConstraint context name);
		time: #BEFORE;
		event: #'INSERT OR UPDATE';
		granularity: #'EACH ROW'.
	
	body := String new writeStream.
	
	varName := MocoSqlOracleEscaping escapeName: (MocoNamingUtils toShortName: (aMocoOclRdbMandatoryMultiplicityConstraint sourceTable name)).
	
	body
		nextPutAll: 'DECLARE';
		cr;
		nextPutAll: '  "l_count" NUMBER := 0;';
		cr;
		nextPutAll: 'BEGIN';
		cr;
		nextPutAll: '  SELECT COUNT(1) INTO "l_count" FROM ';
		nextPutAll: (MocoSqlOracleEscaping escapeName: (aMocoOclRdbMandatoryMultiplicityConstraint sourceTable name));
		nextPutAll: ' ';
		nextPutAll: varName;
		nextPutAll: ' WHERE ';
		nextPutAll: varName;
		nextPutAll: '.';
		nextPutAll: (MocoSqlOracleEscaping escapeName: (aMocoOclRdbMandatoryMultiplicityConstraint sourceColumn name));
		nextPutAll: ' = :new.';
		nextPutAll: (MocoSqlOracleEscaping escapeName: (aMocoOclRdbMandatoryMultiplicityConstraint targetColumn name));
		nextPutAll: ';';
		cr;
		nextPutAll: '  IF "l_count" = 0 THEN';
		cr;
		nextPutAll: '    raise_application_error(-20101, ';
		nextPutAll: (MocoSqlOracleEscaping escapeLiteral: ('OCL constraint ' , (aMocoOclRdbMandatoryMultiplicityConstraint name) , ' violated!'));
		nextPutAll: ');';
		cr;
		nextPutAll: '  END IF;';
		cr;
		nextPutAll: 'END;'.
	
	trigger body: (body contents).
	
	^ trigger
]
