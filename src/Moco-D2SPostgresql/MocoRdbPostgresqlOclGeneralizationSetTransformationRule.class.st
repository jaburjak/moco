"
Transforms the generalization set OCL constraint into a series of TRIGGER definitions.
"
Class {
	#name : 'MocoRdbPostgresqlOclGeneralizationSetTransformationRule',
	#superclass : 'MocoTransformationRule',
	#category : 'Moco-D2SPostgresql-Rule',
	#package : 'Moco-D2SPostgresql',
	#tag : 'Rule'
}

{ #category : 'transforming' }
MocoRdbPostgresqlOclGeneralizationSetTransformationRule >> execute [
	| ocls |
	ocls := engine input
		selectElementsOfKind: MocoOclRdbGeneralizationSetConstraint
		notGuarded: #MocoRdbPostgresqlOclGeneralizationSetTransformationRule.
	
	ocls do: [ :each |
		| triggers |
		triggers := OrderedCollection new.
		
		triggers
			add: (self generateSuperclassTrigger: each);
			addAll: (self generateSubclassInsertTriggers: each);
			addAll: (self generateSubclassUpdateTriggers: each);
			addAll: (self generateSubclassDeleteTriggers: each).
		
		triggers do: [ :e | engine addOutputElement: e withSource: each ].
		
		engine input guard: each with: #MocoRdbPostgresqlOclGeneralizationSetTransformationRule
	]
]

{ #category : 'private - transforming' }
MocoRdbPostgresqlOclGeneralizationSetTransformationRule >> generateSubclassDeleteTrigger: aMocoOclRdbGeneralizationSetTransformationConstraint forTable: aMocoRdbTable withColumn: aMocoRdbColumn [
	| trigger body varName |
	trigger := MocoSqlPostgresqlCreateTrigger new.
	
	trigger name: ((MocoNamingUtils toUpperSnakeCase: (aMocoOclRdbGeneralizationSetTransformationConstraint name)) , '_' , (aMocoRdbTable name) , '_DEL');
		table: (aMocoRdbTable name);
		time: #BEFORE;
		event: #DELETE;
		granularity: #'EACH ROW'.
		
	body := String new writeStream.
	
	varName := MocoSqlPostgresqlEscaping escapeName: (MocoNamingUtils toShortName: (aMocoOclRdbGeneralizationSetTransformationConstraint context name)).
	
	body
		nextPutAll: 'IF EXISTS (';
		cr;
		nextPutAll: '  SELECT 1 FROM ';
		nextPutAll: (MocoSqlPostgresqlEscaping escapeName: (aMocoOclRdbGeneralizationSetTransformationConstraint context name));
		nextPutAll: ' ';
		nextPutAll: varName;
		nextPutAll: ' WHERE ';
		nextPutAll: varName;
		nextPutAll: '.';
		nextPutAll: (MocoSqlPostgresqlEscaping escapeName: (aMocoOclRdbGeneralizationSetTransformationConstraint keyColumn name));
		nextPutAll: ' = OLD.';
		nextPutAll: (MocoSqlPostgresqlEscaping escapeName: (aMocoRdbColumn name));
		cr;
		nextPutAll: ') THEN';
		cr;
		nextPutAll: '  RAISE EXCEPTION ';
		nextPutAll: (MocoSqlPostgresqlEscaping escapeLiteral: ('OCL constraint ' , (aMocoOclRdbGeneralizationSetTransformationConstraint name) , ' violated!'));
		nextPutAll: ';';
		cr;
		nextPutAll: 'END IF;';
		cr;
		nextPutAll: 'RETURN OLD;'.
	
	trigger body: (body contents).
	
	^ trigger
]

{ #category : 'private - processing' }
MocoRdbPostgresqlOclGeneralizationSetTransformationRule >> generateSubclassDeleteTriggers: aMocoOclRdbGeneralizationSetTransformationConstraint [
	^ aMocoOclRdbGeneralizationSetTransformationConstraint tables collect: [ :each |
		self generateSubclassDeleteTrigger: aMocoOclRdbGeneralizationSetTransformationConstraint forTable: (each first) withColumn: (each last)
	]
]

{ #category : 'private - transforming' }
MocoRdbPostgresqlOclGeneralizationSetTransformationRule >> generateSubclassInsertTrigger: aMocoOclRdbGeneralizationSetTransformationConstraint forTable: aMocoRdbTable withColumn: aMocoRdbColumn [
	| trigger body varName |
	trigger := MocoSqlPostgresqlCreateTrigger new.
	
	trigger name: ((MocoNamingUtils toUpperSnakeCase: (aMocoOclRdbGeneralizationSetTransformationConstraint name)) , '_' , (aMocoRdbTable name) , '_INS');
		table: (aMocoRdbTable name);
		time: #BEFORE;
		event: #INSERT;
		granularity: #'EACH ROW'.
		
	body := String new writeStream.
	
	varName := MocoSqlPostgresqlEscaping escapeName: (MocoNamingUtils toShortName: (aMocoOclRdbGeneralizationSetTransformationConstraint context name)).
	
	body
		nextPutAll: 'IF EXISTS (';
		cr;
		nextPutAll: '  SELECT 1 FROM ';
		nextPutAll: (MocoSqlPostgresqlEscaping escapeName: (aMocoOclRdbGeneralizationSetTransformationConstraint context name));
		nextPutAll: ' ';
		nextPutAll: varName;
		nextPutAll: ' WHERE ';
		nextPutAll: varName;
		nextPutAll: '.';
		nextPutAll: (MocoSqlPostgresqlEscaping escapeName: (aMocoOclRdbGeneralizationSetTransformationConstraint keyColumn name));
		nextPutAll: ' = NEW.';
		nextPutAll: (MocoSqlPostgresqlEscaping escapeName: (aMocoRdbColumn name));
		cr;
		nextPutAll: ') THEN';
		cr;
		nextPutAll: '  RAISE EXCEPTION ';
		nextPutAll: (MocoSqlPostgresqlEscaping escapeLiteral: ('OCL constraint ' , (aMocoOclRdbGeneralizationSetTransformationConstraint name) , ' violated!'));
		nextPutAll: ';';
		cr;
		nextPutAll: 'END IF;';
		cr;
		nextPutAll: 'RETURN NEW;'.
	
	trigger body: (body contents).
	
	^ trigger
]

{ #category : 'private - processing' }
MocoRdbPostgresqlOclGeneralizationSetTransformationRule >> generateSubclassInsertTriggers: aMocoOclRdbGeneralizationSetTransformationConstraint [
	^ aMocoOclRdbGeneralizationSetTransformationConstraint tables collect: [ :each |
		self generateSubclassInsertTrigger: aMocoOclRdbGeneralizationSetTransformationConstraint forTable: (each first) withColumn: (each last)
	]
]

{ #category : 'private - transforming' }
MocoRdbPostgresqlOclGeneralizationSetTransformationRule >> generateSubclassUpdateTrigger: aMocoOclRdbGeneralizationSetTransformationConstraint forTable: aMocoRdbTable withColumn: aMocoRdbColumn [
	| trigger body varName |
	trigger := MocoSqlPostgresqlCreateTrigger new.
	
	trigger name: ((MocoNamingUtils toUpperSnakeCase: (aMocoOclRdbGeneralizationSetTransformationConstraint name)) , '_' , (aMocoRdbTable name) , '_UPD');
		table: (aMocoRdbTable name);
		time: #BEFORE;
		event: #UPDATE;
		granularity: #'EACH ROW'.
		
	body := String new writeStream.
	
	varName := MocoSqlPostgresqlEscaping escapeName: (MocoNamingUtils toShortName: (aMocoOclRdbGeneralizationSetTransformationConstraint context name)).
	
	body
		nextPutAll: 'IF OLD.';
		nextPutAll: (MocoSqlPostgresqlEscaping escapeName: (aMocoRdbColumn name));
		nextPutAll: ' <> NEW.';
		nextPutAll: (MocoSqlPostgresqlEscaping escapeName: (aMocoRdbColumn name));
		nextPutAll: ' AND ';
		cr;
		nextPutAll: '  EXISTS (SELECT 1 FROM ';
		nextPutAll: (MocoSqlPostgresqlEscaping escapeName: (aMocoOclRdbGeneralizationSetTransformationConstraint context name));
		nextPutAll: ' ';
		nextPutAll: varName;
		nextPutAll: ' WHERE ';
		nextPutAll: varName;
		nextPutAll: '.';
		nextPutAll: (MocoSqlPostgresqlEscaping escapeName: (aMocoOclRdbGeneralizationSetTransformationConstraint keyColumn name));
		nextPutAll: ' = OLD.';
		nextPutAll: (MocoSqlPostgresqlEscaping escapeName: (aMocoRdbColumn name));
		nextPutAll: ' OR ';
		nextPutAll: varName;
		nextPutAll: '.';
		nextPutAll: (MocoSqlPostgresqlEscaping escapeName: (aMocoOclRdbGeneralizationSetTransformationConstraint keyColumn name));
		nextPutAll: ' = NEW.';
		nextPutAll: (MocoSqlPostgresqlEscaping escapeName: (aMocoRdbColumn name));
		nextPutAll: ')';
		cr;
		nextPutAll: 'THEN';
		cr;
		nextPutAll: '  RAISE EXCEPTION ';
		nextPutAll: (MocoSqlPostgresqlEscaping escapeLiteral: ('OCL constraint ' , (aMocoOclRdbGeneralizationSetTransformationConstraint name) , ' violated!'));
		nextPutAll: ';';
		cr;
		nextPutAll: 'END IF;';
		cr;
		nextPutAll: 'RETURN NEW;'.
	
	trigger body: (body contents).
	
	^ trigger
]

{ #category : 'private - processing' }
MocoRdbPostgresqlOclGeneralizationSetTransformationRule >> generateSubclassUpdateTriggers: aMocoOclRdbGeneralizationSetTransformationConstraint [
	^ aMocoOclRdbGeneralizationSetTransformationConstraint tables collect: [ :each |
		self generateSubclassUpdateTrigger: aMocoOclRdbGeneralizationSetTransformationConstraint forTable: (each first) withColumn: (each last)
	]
]

{ #category : 'private - processing' }
MocoRdbPostgresqlOclGeneralizationSetTransformationRule >> generateSuperclassTrigger: aMocoOclRdbGeneralizationSetTransformationConstraint [
	| trigger body |
	trigger := MocoSqlPostgresqlCreateTrigger new.
	
	trigger name: (MocoNamingUtils toUpperSnakeCase: (aMocoOclRdbGeneralizationSetTransformationConstraint name));
		table: (aMocoOclRdbGeneralizationSetTransformationConstraint context name);
		time: #BEFORE;
		event: #'INSERT OR UPDATE';
		granularity: #'EACH ROW'.
		
	body := String new writeStream.
	
	body nextPutAll: 'IF NOT ('.
	
	(aMocoOclRdbGeneralizationSetTransformationConstraint values) with: (aMocoOclRdbGeneralizationSetTransformationConstraint configurations) do: [ :v :c |
		(v = aMocoOclRdbGeneralizationSetTransformationConstraint values first) ifTrue: [ body nextPutAll: '(' ] ifFalse: [ body cr; nextPutAll: '  ) OR (' ].
		body
			cr;
			nextPutAll: '    NEW.';
			nextPutAll: (MocoSqlPostgresqlEscaping escapeName: (aMocoOclRdbGeneralizationSetTransformationConstraint discriminatorColumn name));
			nextPutAll: ' = ';
			nextPutAll: (MocoSqlPostgresqlEscaping escapeLiteral: v).
		(aMocoOclRdbGeneralizationSetTransformationConstraint tables) with: c do: [ :t :e |
			| varName |
			varName := MocoSqlPostgresqlEscaping escapeName: (MocoNamingUtils toShortName: (t first name)).
			body cr; nextPutAll: '    AND '.
			e ifFalse: [ body nextPutAll: 'NOT ' ].
			body
				nextPutAll: 'EXISTS (SELECT 1 FROM ';
				nextPutAll: (MocoSqlPostgresqlEscaping escapeName: (t first name));
				nextPutAll: ' ';
				nextPutAll: varName;
				nextPutAll: ' WHERE ';
				nextPutAll: varName;
				nextPutAll: '.';
				nextPutAll: (MocoSqlPostgresqlEscaping escapeName: (t last name));
				nextPutAll: ' = NEW.';
				nextPutAll: (MocoSqlPostgresqlEscaping escapeName: (aMocoOclRdbGeneralizationSetTransformationConstraint keyColumn name));
				nextPutAll: ')'
		]
	].

	body cr.
	aMocoOclRdbGeneralizationSetTransformationConstraint values ifNotEmpty: [ body nextPutAll: ')' ].

	body
		nextPutAll: ') THEN';
		cr;
		nextPutAll: '  RAISE EXCEPTION ';
		nextPutAll: (MocoSqlPostgresqlEscaping escapeLiteral: ('OCL constraint ' , (aMocoOclRdbGeneralizationSetTransformationConstraint name) , ' violated!'));
		nextPutAll: ';';
		cr;
		nextPutAll: 'END IF;';
		cr;
		nextPutAll: 'RETURN NEW;'.
	
	trigger body: (body contents).
	
	^ trigger
]
