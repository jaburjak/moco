"
Transforms OCL constraints for exclusive phase associations to CREATE TRIGGER statements in an Oracle relational database.
"
Class {
	#name : #MocoRdbOclExclusiveAssociationTransformationRule,
	#superclass : #MocoTransformationRule,
	#category : #'Moco-D2S-Rule'
}

{ #category : #transforming }
MocoRdbOclExclusiveAssociationTransformationRule >> execute [
	| ocls |
	ocls := engine input
		selectElementsOfKind: MocoOclRdbExclusiveAssociationCondition
		notGuarded: #MocoRdbOclExclusiveAssociationTransformationRule.
	
	ocls do: [ :each |
		| triggers |
		triggers := OrderedCollection new.
		
		triggers
			add: (self generateSourceTrigger: each);
			addAll: (self generateInsertTriggers: each);
			addAll: (self generateUpdateTriggers: each).
		
		triggers do: [ :e | engine addOutputElement: e withSource: each ].
		engine input guard: each with: #MocoRdbOclExclusiveAssociationTransformationRule
	]
]

{ #category : #'private - processing' }
MocoRdbOclExclusiveAssociationTransformationRule >> generateExists: aBoolean clauseFor: aMocoRdbTable andColumn: aMocoRdbColumn withReferenced: aMocoRdbColumn2 andLabel: aString [
	| str varName |
	str := String new writeStream.
	
	varName := MocoNamingUtils toShortName: (aMocoRdbTable name).
	
	(((aString first = $") and: [ aString last = $" ]) and: [ varName = ((aString allButFirst: 1) allButLast: 1) ])
		ifTrue: [ varName := (varName , '2') ].
	
	varName := MocoSqlOracleEscaping escapeName: varName.
	
	aBoolean ifFalse: [ str nextPutAll: 'NOT ' ].
	
	str
		nextPutAll: 'EXISTS (SELECT 1 FROM ';
		nextPutAll: (MocoSqlOracleEscaping escapeName: (aMocoRdbTable name));
		nextPutAll: ' ';
		nextPutAll: varName;
		nextPutAll: ' WHERE ';
		nextPutAll: varName;
		nextPutAll: '.';
		nextPutAll: (MocoSqlOracleEscaping escapeName: (aMocoRdbColumn name));
		nextPutAll: ' = ';
		nextPutAll: aString;
		nextPutAll: '.';
		nextPutAll: (MocoSqlOracleEscaping escapeName: (aMocoRdbColumn2 name));
		nextPutAll: ')'.
	
	^ str contents
]

{ #category : #'private - processing' }
MocoRdbOclExclusiveAssociationTransformationRule >> generateInsertTrigger: aMocoOclRdbExclusiveAssociationCondition forTable: aMocoRdbTable [
	| trigger body first column |
	trigger := MocoSqlOracleCreateTrigger new.
	
	trigger name: ((MocoNamingUtils toUpperSnakeCase: (aMocoOclRdbExclusiveAssociationCondition name)) , '_' , (aMocoRdbTable name) , '_INS');
		table: (aMocoRdbTable name);
		time: #BEFORE;
		event: #INSERT;
		granularity: #'EACH ROW'.
	
	body := String new writeStream.
	
	body
		nextPutAll: 'DECLARE';
		cr;
		nextPutAll: '  "l_count" NUMBER;';
		cr;
		nextPutAll: 'BEGIN';
		cr;
		nextPutAll: '  SELECT COUNT(1) INTO "l_count" FROM DUAL WHERE ('.
	
	(aMocoOclRdbExclusiveAssociationCondition referencingTables) with: (aMocoOclRdbExclusiveAssociationCondition referencingColumns) do: [ :t :c |
		((t first) == aMocoRdbTable) ifTrue: [ column := c first ]
	].
	
	first := true.
	
	(aMocoOclRdbExclusiveAssociationCondition referencingTables) with: (aMocoOclRdbExclusiveAssociationCondition referencingColumns) do: [ :t :c |
		((t first) == aMocoRdbTable) ifFalse: [
			body cr; nextPutAll: '    '.
			first ifFalse: [ body nextPutAll: 'OR ' ].
			body nextPutAll: (self generateExists: true clauseFor: (t first) andColumn: (c first) withReferenced: column andLabel: ':new').
			first := false
		]
	].

	body
		nextPutAll: ');';
		cr;
		nextPutAll: '  IF "l_count" > 0 THEN';
		cr;
		nextPutAll: '    raise_application_error(-20101, ';
		nextPutAll: (MocoSqlOracleEscaping escapeLiteral: ('OCL constraint ' , (aMocoOclRdbExclusiveAssociationCondition name) , ' violated!'));
		nextPutAll: ');';
		cr;
		nextPutAll: '  END IF;';
		cr;
		nextPutAll: 'END;'.
	
	trigger body: (body contents).
	
	^ trigger
]

{ #category : #'private - processing' }
MocoRdbOclExclusiveAssociationTransformationRule >> generateInsertTriggers: aMocoOclRdbExclusiveAssociationCondition [
	| triggers |
	triggers := OrderedCollection new.
	
	((aMocoOclRdbExclusiveAssociationCondition referencingTables size) < 2) ifTrue: [ ^ triggers ].
	
	triggers addAll: (aMocoOclRdbExclusiveAssociationCondition referencingTables collect: [ :each | self generateInsertTrigger: aMocoOclRdbExclusiveAssociationCondition forTable: (each first) ] ).
	
	^ triggers
]

{ #category : #'private - processing' }
MocoRdbOclExclusiveAssociationTransformationRule >> generateSourceTrigger: aMocoOclRdbExclusiveAssociationCondition [
	| trigger body |
	trigger := MocoSqlOracleCreateTrigger new.
	
	trigger name: (MocoNamingUtils toUpperSnakeCase: (aMocoOclRdbExclusiveAssociationCondition name));
		table: (aMocoOclRdbExclusiveAssociationCondition context name);
		time: #BEFORE;
		event: #'INSERT OR UPDATE';
		granularity: #'EACH ROW'.
	
	body := String new writeStream.
	
	body
		nextPutAll: 'DECLARE';
		cr;
		nextPutAll: '  "l_count" NUMBER;';
		cr;
		nextPutAll: 'BEGIN';
		cr;
		nextPutAll: '  SELECT COUNT(1) INTO "l_count" FROM DUAL WHERE ('.
	
	aMocoOclRdbExclusiveAssociationCondition referencingTables do: [ :each |
		| str |
		
		((each size) > 1) ifTrue: [ self error: 'MocoRdbOclExclusiveAssociationTransformationRule cannot transform a constraint with overlapping associations.' ].
		
		str := String new writeStream.
		
		(each == (aMocoOclRdbExclusiveAssociationCondition referencingTables first))
			ifTrue: [ str cr; nextPutAll: '    (' ]
			ifFalse: [ str cr; nextPutAll: '    OR (' ].
		
		(aMocoOclRdbExclusiveAssociationCondition referencingTables) with: (aMocoOclRdbExclusiveAssociationCondition referencingColumns) do: [ :t :c |
			str nextPutAll: (self generateExists: (t == each) clauseFor: (t first) andColumn: (c first) withReferenced: (aMocoOclRdbExclusiveAssociationCondition column) andLabel: ':new').
			(t == (aMocoOclRdbExclusiveAssociationCondition referencingTables last)) ifFalse: [ str cr; nextPutAll: '      AND ' ]
		].
		
		str nextPutAll: ')'.
		
		body nextPutAll: (str contents)
	].

	body
		nextPutAll: ');';
		cr;
		nextPutAll: '  IF "l_count" = 0 THEN';
		cr;
		nextPutAll: '    raise_application_error(-20101, ';
		nextPutAll: (MocoSqlOracleEscaping escapeLiteral: ('OCL constraint ' , (aMocoOclRdbExclusiveAssociationCondition name) , ' violated!'));
		nextPutAll: ');';
		cr;
		nextPutAll: '  END IF;';
		cr;
		nextPutAll: 'END;'.
	
	trigger body: (body contents).
	
	^ trigger
]

{ #category : #'private - processing' }
MocoRdbOclExclusiveAssociationTransformationRule >> generateUpdateTrigger: aMocoOclRdbExclusiveAssociationCondition forTable: aMocoRdbTable [
	| trigger body varName |
	trigger := MocoSqlOracleCreateTrigger new.
	
	trigger name: ((MocoNamingUtils toUpperSnakeCase: (aMocoOclRdbExclusiveAssociationCondition name)) , '_' , (aMocoRdbTable name) , '_UPD_DEL');
		table: (aMocoRdbTable name);
		time: #AFTER;
		event: #'UPDATE OR DELETE'.
	
	body := String new writeStream.
	
	varName := MocoSqlOracleEscaping escapeName: (MocoNamingUtils toShortName: (aMocoOclRdbExclusiveAssociationCondition context name)).
	
	body
		nextPutAll: 'DECLARE';
		cr;
		nextPutAll: '  "l_count" NUMBER;';
		cr;
		nextPutAll: 'BEGIN';
		cr;
		nextPutAll: '  SELECT COUNT(1) INTO "l_count" FROM ';
		nextPutAll: (MocoSqlOracleEscaping escapeName: (aMocoOclRdbExclusiveAssociationCondition context name));
		nextPutAll: ' ';
		nextPutAll: varName;
		nextPutAll: ' WHERE NOT ('.
	
	aMocoOclRdbExclusiveAssociationCondition referencingTables do: [ :each |
		body cr; nextPutAll: '    '.
		(each == (aMocoOclRdbExclusiveAssociationCondition referencingTables first)) ifFalse: [ body nextPutAll: 'OR ' ].
		body nextPutAll: '('.

		(aMocoOclRdbExclusiveAssociationCondition referencingTables) with: (aMocoOclRdbExclusiveAssociationCondition referencingColumns) do: [ :t :c |
			body nextPutAll: (self generateExists: (t == each) clauseFor: (t first) andColumn: (c first) withReferenced: (aMocoOclRdbExclusiveAssociationCondition column) andLabel: varName).
			(t == (aMocoOclRdbExclusiveAssociationCondition referencingTables last)) ifFalse: [ body cr; nextPutAll: '      AND ' ]
		].
		
		body nextPutAll: ')'
	].

	body
		nextPutAll: ');';
		cr;
		nextPutAll: '  IF "l_count" > 0 THEN';
		cr;
		nextPutAll: '    raise_application_error(-20101, ';
		nextPutAll: (MocoSqlOracleEscaping escapeLiteral: ('OCL constraint ' , (aMocoOclRdbExclusiveAssociationCondition name) , ' violated!'));
		nextPutAll: ');';
		cr;
		nextPutAll: '  END IF;';
		cr;
		nextPutAll: 'END;'.
	
	trigger body: (body contents).
	
	^ trigger
]

{ #category : #'private - processing' }
MocoRdbOclExclusiveAssociationTransformationRule >> generateUpdateTriggers: aMocoOclRdbExclusiveAssociationCondition [
	^ (aMocoOclRdbExclusiveAssociationCondition referencingTables collect: [ :each | self generateUpdateTrigger: aMocoOclRdbExclusiveAssociationCondition forTable: (each first) ] )
]
