"
Transforms the generalization set OCL constraint into a series of TRIGGER definitions.
"
Class {
	#name : 'MocoRdbOracleOclGeneralizationSetTransformationRule',
	#superclass : 'MocoTransformationRule',
	#category : 'Moco-D2SOracle-Rule',
	#package : 'Moco-D2SOracle',
	#tag : 'Rule'
}

{ #category : 'transforming' }
MocoRdbOracleOclGeneralizationSetTransformationRule >> execute [
	| ocls |
	ocls := engine input
		selectElementsOfKind: MocoOclRdbGeneralizationSetConstraint
		notGuarded: #MocoRdbOracleOclGeneralizationSetTransformationRule.
	
	ocls do: [ :each |
		| triggers |
		triggers := OrderedCollection new.
		
		triggers
			add: (self generateSuperclassTrigger: each);
			addAll: (self generateSubclassInsertTriggers: each);
			addAll: (self generateSubclassUpdateTriggers: each);
			addAll: (self generateSubclassDeleteTriggers: each).
		
		triggers do: [ :e | engine addOutputElement: e withSource: each ].
		
		engine input guard: each with: #MocoRdbOracleOclGeneralizationSetTransformationRule
	]
]

{ #category : 'private - transforming' }
MocoRdbOracleOclGeneralizationSetTransformationRule >> generateSubclassDeleteTrigger: aMocoOclRdbGeneralizationSetTransformationConstraint forTable: aMocoRdbTable withColumn: aMocoRdbColumn [
	| trigger body varName |
	trigger := MocoSqlOracleCreateTrigger new.
	
	trigger name: ((MocoNamingUtils toUpperSnakeCase: (aMocoOclRdbGeneralizationSetTransformationConstraint name)) , '_' , (aMocoRdbTable name) , '_DEL');
		table: (aMocoRdbTable name);
		time: #BEFORE;
		event: #DELETE;
		granularity: #'EACH ROW'.
		
	body := String new writeStream.
	
	varName := MocoSqlOracleEscaping escapeName: (MocoNamingUtils toShortName: (aMocoOclRdbGeneralizationSetTransformationConstraint context name)).
	
	body
		nextPutAll: 'DECLARE';
		cr;
		nextPutAll: '  "l_count" NUMBER := 0;';
		cr;
		nextPutAll: 'BEGIN';
		cr;
		nextPutAll: '  SELECT COUNT(*) INTO "l_count" FROM DUAL WHERE EXISTS (';
		cr;
		nextPutAll: '    SELECT 1 FROM ';
		nextPutAll: (MocoSqlOracleEscaping escapeName: (aMocoOclRdbGeneralizationSetTransformationConstraint context name));
		nextPutAll: ' ';
		nextPutAll: varName;
		nextPutAll: ' WHERE ';
		nextPutAll: varName;
		nextPutAll: '.';
		nextPutAll: (MocoSqlOracleEscaping escapeName: (aMocoOclRdbGeneralizationSetTransformationConstraint keyColumn name));
		nextPutAll: ' = :old.';
		nextPutAll: (MocoSqlOracleEscaping escapeName: (aMocoRdbColumn name));
		nextPutAll: ');';
		cr;
		nextPutAll: '  IF "l_count" > 0 THEN';
		cr;
		nextPutAll: '    raise_application_error(-20101, ';
		nextPutAll: (MocoSqlOracleEscaping escapeLiteral: ('OCL constraint ' , (aMocoOclRdbGeneralizationSetTransformationConstraint name) , ' violated!'));
		nextPutAll: ');';
		cr;
		nextPutAll: '  END IF;';
		cr;
		nextPutAll: 'END;'.
	
	trigger body: (body contents).
	
	^ trigger
]

{ #category : 'private - processing' }
MocoRdbOracleOclGeneralizationSetTransformationRule >> generateSubclassDeleteTriggers: aMocoOclRdbGeneralizationSetTransformationConstraint [
	^ aMocoOclRdbGeneralizationSetTransformationConstraint tables collect: [ :each |
		self generateSubclassDeleteTrigger: aMocoOclRdbGeneralizationSetTransformationConstraint forTable: (each first) withColumn: (each last)
	]
]

{ #category : 'private - transforming' }
MocoRdbOracleOclGeneralizationSetTransformationRule >> generateSubclassInsertTrigger: aMocoOclRdbGeneralizationSetTransformationConstraint forTable: aMocoRdbTable withColumn: aMocoRdbColumn [
	| trigger body varName |
	trigger := MocoSqlOracleCreateTrigger new.
	
	trigger name: ((MocoNamingUtils toUpperSnakeCase: (aMocoOclRdbGeneralizationSetTransformationConstraint name)) , '_' , (aMocoRdbTable name) , '_INS');
		table: (aMocoRdbTable name);
		time: #BEFORE;
		event: #INSERT;
		granularity: #'EACH ROW'.
		
	body := String new writeStream.
	
	varName := MocoSqlOracleEscaping escapeName: (MocoNamingUtils toShortName: (aMocoOclRdbGeneralizationSetTransformationConstraint context name)).
	
	body
		nextPutAll: 'DECLARE';
		cr;
		nextPutAll: '  "l_count" NUMBER := 0;';
		cr;
		nextPutAll: 'BEGIN';
		cr;
		nextPutAll: '  SELECT COUNT(*) INTO "l_count" FROM DUAL WHERE EXISTS (';
		cr;
		nextPutAll: '    SELECT 1 FROM ';
		nextPutAll: (MocoSqlOracleEscaping escapeName: (aMocoOclRdbGeneralizationSetTransformationConstraint context name));
		nextPutAll: ' ';
		nextPutAll: varName;
		nextPutAll: ' WHERE ';
		nextPutAll: varName;
		nextPutAll: '.';
		nextPutAll: (MocoSqlOracleEscaping escapeName: (aMocoOclRdbGeneralizationSetTransformationConstraint keyColumn name));
		nextPutAll: ' = :new.';
		nextPutAll: (MocoSqlOracleEscaping escapeName: (aMocoRdbColumn name));
		nextPutAll: ');';
		cr;
		nextPutAll: '  IF "l_count" > 0 THEN';
		cr;
		nextPutAll: '    raise_application_error(-20101, ';
		nextPutAll: (MocoSqlOracleEscaping escapeLiteral: ('OCL constraint ' , (aMocoOclRdbGeneralizationSetTransformationConstraint name) , ' violated!'));
		nextPutAll: ');';
		cr;
		nextPutAll: '  END IF;';
		cr;
		nextPutAll: 'END;'.
	
	trigger body: (body contents).
	
	^ trigger
]

{ #category : 'private - processing' }
MocoRdbOracleOclGeneralizationSetTransformationRule >> generateSubclassInsertTriggers: aMocoOclRdbGeneralizationSetTransformationConstraint [
	^ aMocoOclRdbGeneralizationSetTransformationConstraint tables collect: [ :each |
		self generateSubclassInsertTrigger: aMocoOclRdbGeneralizationSetTransformationConstraint forTable: (each first) withColumn: (each last)
	]
]

{ #category : 'private - transforming' }
MocoRdbOracleOclGeneralizationSetTransformationRule >> generateSubclassUpdateTrigger: aMocoOclRdbGeneralizationSetTransformationConstraint forTable: aMocoRdbTable withColumn: aMocoRdbColumn [
	| trigger body varName |
	trigger := MocoSqlOracleCreateTrigger new.
	
	trigger name: ((MocoNamingUtils toUpperSnakeCase: (aMocoOclRdbGeneralizationSetTransformationConstraint name)) , '_' , (aMocoRdbTable name) , '_UPD');
		table: (aMocoRdbTable name);
		time: #BEFORE;
		event: #UPDATE;
		granularity: #'EACH ROW'.
		
	body := String new writeStream.
	
	varName := MocoSqlOracleEscaping escapeName: (MocoNamingUtils toShortName: (aMocoOclRdbGeneralizationSetTransformationConstraint context name)).
	
	body
		nextPutAll: 'DECLARE';
		cr;
		nextPutAll: '  "l_count" NUMBER := 0;';
		cr;
		nextPutAll: 'BEGIN';
		cr;
		nextPutAll: '  IF :old.';
		nextPutAll: (MocoSqlOracleEscaping escapeName: (aMocoRdbColumn name));
		nextPutAll: ' <> :new.';
		nextPutAll: (MocoSqlOracleEscaping escapeName: (aMocoRdbColumn name));
		nextPutAll: ' THEN';
		cr;
		nextPutAll: '    SELECT COUNT(*) INTO "l_count" FROM DUAL WHERE EXISTS (';
		cr;
		nextPutAll: '      SELECT 1 FROM ';
		nextPutAll: (MocoSqlOracleEscaping escapeName: (aMocoOclRdbGeneralizationSetTransformationConstraint context name));
		nextPutAll: ' ';
		nextPutAll: varName;
		nextPutAll: ' WHERE ';
		nextPutAll: varName;
		nextPutAll: '.';
		nextPutAll: (MocoSqlOracleEscaping escapeName: (aMocoOclRdbGeneralizationSetTransformationConstraint keyColumn name));
		nextPutAll: ' = :old.';
		nextPutAll: (MocoSqlOracleEscaping escapeName: (aMocoRdbColumn name));
		nextPutAll: ' OR ';
		nextPutAll: varName;
		nextPutAll: '.';
		nextPutAll: (MocoSqlOracleEscaping escapeName: (aMocoOclRdbGeneralizationSetTransformationConstraint keyColumn name));
		nextPutAll: ' = :new.';
		nextPutAll: (MocoSqlOracleEscaping escapeName: (aMocoRdbColumn name));
		nextPutAll: ');';
		cr;
		nextPutAll: '  END IF;';
		cr;
		nextPutAll: '  IF "l_count" > 0 THEN';
		cr;
		nextPutAll: '    raise_application_error(-20101, ';
		nextPutAll: (MocoSqlOracleEscaping escapeLiteral: ('OCL constraint ' , (aMocoOclRdbGeneralizationSetTransformationConstraint name) , ' violated!'));
		nextPutAll: ');';
		cr;
		nextPutAll: '  END IF;';
		cr;
		nextPutAll: 'END;'.
	
	trigger body: (body contents).
	
	^ trigger
]

{ #category : 'private - processing' }
MocoRdbOracleOclGeneralizationSetTransformationRule >> generateSubclassUpdateTriggers: aMocoOclRdbGeneralizationSetTransformationConstraint [
	^ aMocoOclRdbGeneralizationSetTransformationConstraint tables collect: [ :each |
		self generateSubclassUpdateTrigger: aMocoOclRdbGeneralizationSetTransformationConstraint forTable: (each first) withColumn: (each last)
	]
]

{ #category : 'private - processing' }
MocoRdbOracleOclGeneralizationSetTransformationRule >> generateSuperclassTrigger: aMocoOclRdbGeneralizationSetTransformationConstraint [
	| trigger body |
	trigger := MocoSqlOracleCreateTrigger new.
	
	trigger name: (MocoNamingUtils toUpperSnakeCase: (aMocoOclRdbGeneralizationSetTransformationConstraint name));
		table: (aMocoOclRdbGeneralizationSetTransformationConstraint context name);
		time: #BEFORE;
		event: #'INSERT OR UPDATE';
		granularity: #'EACH ROW'.
		
	body := String new writeStream.
	
	body
		nextPutAll: 'DECLARE';
		cr;
		nextPutAll: '  "l_count" NUMBER := 0;';
		cr;
		nextPutAll: 'BEGIN';
		cr;
		nextPutAll: '  SELECT COUNT(*) INTO "l_count" FROM DUAL WHERE (';
		cr.
	
	(aMocoOclRdbGeneralizationSetTransformationConstraint values) with: (aMocoOclRdbGeneralizationSetTransformationConstraint configurations) do: [ :v :c |
		body nextPutAll: '    '.
		(v = aMocoOclRdbGeneralizationSetTransformationConstraint values first) ifFalse: [ body nextPutAll: 'OR ' ].
		body
			nextPutAll: '(:new.';
			nextPutAll: (MocoSqlOracleEscaping escapeName: (aMocoOclRdbGeneralizationSetTransformationConstraint discriminatorColumn name));
			nextPutAll: ' = ';
			nextPutAll: (MocoSqlOracleEscaping escapeLiteral: v).
		(aMocoOclRdbGeneralizationSetTransformationConstraint tables) with: c do: [ :t :e |
			| varName |
			varName := MocoSqlOracleEscaping escapeName: (MocoNamingUtils toShortName: (t first name)).
			body cr; nextPutAll: '      AND '.
			e ifFalse: [ body nextPutAll: 'NOT ' ].
			body
				nextPutAll: 'EXISTS (SELECT 1 FROM ';
				nextPutAll: (MocoSqlOracleEscaping escapeName: (t first name));
				nextPutAll: ' ';
				nextPutAll: varName;
				nextPutAll: ' WHERE ';
				nextPutAll: varName;
				nextPutAll: '.';
				nextPutAll: (MocoSqlOracleEscaping escapeName: (t last name));
				nextPutAll: ' = :new.';
				nextPutAll: (MocoSqlOracleEscaping escapeName: (aMocoOclRdbGeneralizationSetTransformationConstraint keyColumn name));
				nextPutAll: ')'
		].
		body nextPutAll: ')'; cr
	].

	body
		nextPutAll: '  );';
		cr;
		nextPutAll: '  IF "l_count" = 0 THEN';
		cr;
		nextPutAll: '    raise_application_error(-20101, ';
		nextPutAll: (MocoSqlOracleEscaping escapeLiteral: ('OCL constraint ' , (aMocoOclRdbGeneralizationSetTransformationConstraint name) , ' violated!'));
		nextPutAll: ');';
		cr;
		nextPutAll: '  END IF;';
		cr;
		nextPutAll: 'END;'.
	
	trigger body: (body contents).
	
	^ trigger
]
