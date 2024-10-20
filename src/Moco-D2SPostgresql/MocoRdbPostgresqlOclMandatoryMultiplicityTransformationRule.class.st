"
Transforms mandatory association multiplicity OCL constraint to CREATE TRIGGER statements in a PostgreSQL database.
"
Class {
	#name : #MocoRdbPostgresqlOclMandatoryMultiplicityTransformationRule,
	#superclass : #MocoTransformationRule,
	#category : #'Moco-D2SPostgresql-Rule'
}

{ #category : #transforming }
MocoRdbPostgresqlOclMandatoryMultiplicityTransformationRule >> execute [
	| ocls |
	ocls := engine input
		selectElementsOfKind: MocoOclRdbMandatoryMultiplicityConstraint
		notGuarded: #MocoRdbPostgresqlOclMandatoryMultiplicityTransformationRule.
	
	ocls do: [ :each |
		| triggers |
		triggers := OrderedCollection new.
		
		triggers
			add: (self generateTargetTrigger: each);
			add: (self generateSourceTrigger: each).
		
		triggers do: [ :e | engine addOutputElement: e withSource: each ].
		engine input guard: each with: #MocoRdbPostgresqlOclMandatoryMultiplicityTransformationRule
	]
]

{ #category : #'private - processing' }
MocoRdbPostgresqlOclMandatoryMultiplicityTransformationRule >> generateSourceTrigger: aMocoOclRdbMandatoryMultiplicityConstraint [
	| trigger body varName varName2 |
	trigger := MocoSqlPostgresqlCreateTrigger new.
	
	trigger name: ((MocoNamingUtils toUpperSnakeCase: (aMocoOclRdbMandatoryMultiplicityConstraint name)) , '_REL');
		table: (aMocoOclRdbMandatoryMultiplicityConstraint sourceTable name);
		time: #AFTER;
		event: #'UPDATE OR DELETE'.
	
	body := String new writeStream.
	
	varName := MocoSqlPostgresqlEscaping escapeName: (MocoNamingUtils toShortName: (aMocoOclRdbMandatoryMultiplicityConstraint context name)).
	varName2 := MocoSqlPostgresqlEscaping escapeName: (MocoNamingUtils toShortName: (aMocoOclRdbMandatoryMultiplicityConstraint sourceTable name)).
	
	body
		nextPutAll: 'IF EXISTS (';
		cr;
		nextPutAll: '  SELECT 1 FROM ';
		nextPutAll: (MocoSqlPostgresqlEscaping escapeName: (aMocoOclRdbMandatoryMultiplicityConstraint context name));
		nextPutAll: ' ';
		nextPutAll: varName;
		nextPutAll: ' WHERE NOT EXISTS (SELECT 1 FROM ';
		nextPutAll: (MocoSqlPostgresqlEscaping escapeName: (aMocoOclRdbMandatoryMultiplicityConstraint sourceTable name));
		nextPutAll: ' ';
		nextPutAll: varName2;
		nextPutAll: ' WHERE ';
		nextPutAll: varName2;
		nextPutAll: '.';
		nextPutAll: (MocoSqlPostgresqlEscaping escapeName: (aMocoOclRdbMandatoryMultiplicityConstraint sourceColumn name));
		nextPutAll: ' = ';
		nextPutAll: varName;
		nextPutAll: '.';
		nextPutAll: (MocoSqlPostgresqlEscaping escapeName: (aMocoOclRdbMandatoryMultiplicityConstraint targetColumn name));
		nextPutAll: ')';
		cr;
		nextPutAll: ') THEN';
		cr;
		nextPutAll: '  RAISE EXCEPTION ';
		nextPutAll: (MocoSqlPostgresqlEscaping escapeLiteral: ('OCL constraint ' , (aMocoOclRdbMandatoryMultiplicityConstraint name) , ' violated!'));
		nextPutAll: ';';
		cr;
		nextPutAll: 'END IF;';
		cr;
		nextPutAll: 'RETURN NULL;'.
	
	trigger body: (body contents).
	
	^ trigger
]

{ #category : #'private - processing' }
MocoRdbPostgresqlOclMandatoryMultiplicityTransformationRule >> generateTargetTrigger: aMocoOclRdbMandatoryMultiplicityConstraint [
	| trigger body varName |
	trigger := MocoSqlPostgresqlCreateTrigger new.
	
	trigger name: (MocoNamingUtils toUpperSnakeCase: (aMocoOclRdbMandatoryMultiplicityConstraint name));
		table: (aMocoOclRdbMandatoryMultiplicityConstraint context name);
		time: #BEFORE;
		event: #'INSERT OR UPDATE';
		granularity: #'EACH ROW'.
	
	body := String new writeStream.
	
	varName := MocoSqlPostgresqlEscaping escapeName: (MocoNamingUtils toShortName: (aMocoOclRdbMandatoryMultiplicityConstraint sourceTable name)).
	
	body
		nextPutAll: 'IF NOT EXISTS (';
		cr;
		nextPutAll: '  SELECT 1 FROM ';
		nextPutAll: (MocoSqlPostgresqlEscaping escapeName: (aMocoOclRdbMandatoryMultiplicityConstraint sourceTable name));
		nextPutAll: ' ';
		nextPutAll: varName;
		nextPutAll: ' WHERE ';
		nextPutAll: varName;
		nextPutAll: '.';
		nextPutAll: (MocoSqlPostgresqlEscaping escapeName: (aMocoOclRdbMandatoryMultiplicityConstraint sourceColumn name));
		nextPutAll: ' = NEW.';
		nextPutAll: (MocoSqlPostgresqlEscaping escapeName: (aMocoOclRdbMandatoryMultiplicityConstraint targetColumn name));
		cr;
		nextPutAll: ') THEN';
		cr;
		nextPutAll: '  RAISE EXCEPTION ';
		nextPutAll: (MocoSqlPostgresqlEscaping escapeLiteral: ('OCL constraint ' , (aMocoOclRdbMandatoryMultiplicityConstraint name) , ' violated!'));
		nextPutAll: ';';
		cr;
		nextPutAll: 'END IF;';
		cr;
		nextPutAll: 'RETURN NEW;'.
	
	trigger body: (body contents).
	
	^ trigger
]
