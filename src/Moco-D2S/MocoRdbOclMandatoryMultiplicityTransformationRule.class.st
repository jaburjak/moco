"
Transforms mandatory association multiplicity OCL constraint to CREATE TRIGGER statements in an Oracle relational database.
"
Class {
	#name : #MocoRdbOclMandatoryMultiplicityTransformationRule,
	#superclass : #MocoTransformationRule,
	#category : #'Moco-D2S-Rule'
}

{ #category : #transforming }
MocoRdbOclMandatoryMultiplicityTransformationRule >> execute [
	| ocls |
	ocls := engine inModel elements select: [ :each | (each isWrappingType: MocoOclRdbMandatoryMultiplicityConstraint) and: [ each meta isNotProcessedBy: #MocoRdbOclMandatoryMultiplicityTransformationRule ] ].
	
	ocls do: [ :each |
		| triggers |
		triggers := OrderedCollection new.
		
		triggers
			add: (self generateTargetTrigger: (each innerElement));
			add: (self generateSourceTrigger: (each innerElement)).
		
		triggers := triggers collect: [ :t | MocoWrappedElement from: t ].
		
		each meta outElements addAll: triggers.
		engine outModel elements addAll: triggers.
		
		each meta markProcessedBy: #MocoRdbOclMandatoryMultiplicityTransformationRule
	].

	ocls ifNotEmpty: [ engine outModel meta didChange: true ]
]

{ #category : #'private - processing' }
MocoRdbOclMandatoryMultiplicityTransformationRule >> generateSourceTrigger: aMocoOclRdbMandatoryMultiplicityConstraint [
	| trigger body varName varName2 |
	trigger := MocoSqlOracleCreateTrigger new.
	
	trigger name: ((aMocoOclRdbMandatoryMultiplicityConstraint name) , '_REL');
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

{ #category : #'private - processing' }
MocoRdbOclMandatoryMultiplicityTransformationRule >> generateTargetTrigger: aMocoOclRdbMandatoryMultiplicityConstraint [
	| trigger body varName |
	trigger := MocoSqlOracleCreateTrigger new.
	
	trigger name: (aMocoOclRdbMandatoryMultiplicityConstraint name);
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
