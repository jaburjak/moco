"
Transforms OCL constraints for exclusive phase associations to CREATE TRIGGER statements in a PostgreSQL database.
"
Class {
	#name : 'MocoRdbPostgresqlOclExclusiveAssociationTransformationRule',
	#superclass : 'MocoTransformationRule',
	#category : 'Moco-D2SPostgresql-Rule',
	#package : 'Moco-D2SPostgresql',
	#tag : 'Rule'
}

{ #category : 'transforming' }
MocoRdbPostgresqlOclExclusiveAssociationTransformationRule >> execute [
	| ocls |
	ocls := engine input
		selectElementsOfKind: MocoOclRdbExclusiveAssociationCondition
		notGuarded: #MocoRdbPostgresqlOclExclusiveAssociationTransformationRule.
	
	ocls do: [ :each |
		| triggers |
		triggers := OrderedCollection new.
		
		triggers
			add: (self generateSourceTrigger: each);
			addAll: (self generateInsertTriggers: each);
			addAll: (self generateUpdateTriggers: each).
		
		triggers do: [ :e | engine addOutputElement: e withSource: each ].
		engine input guard: each with: #MocoRdbPostgresqlOclExclusiveAssociationTransformationRule
	]
]

{ #category : 'private - processing' }
MocoRdbPostgresqlOclExclusiveAssociationTransformationRule >> generateExists: aBoolean clauseFor: aMocoRdbTable andColumn: aMocoRdbColumn withReferenced: aMocoRdbColumn2 andLabel: aString [
	| str varName |
	str := String new writeStream.
	
	varName := MocoNamingUtils toShortName: (aMocoRdbTable name).
	
	(((aString first = $") and: [ aString last = $" ]) and: [ varName = ((aString allButFirst: 1) allButLast: 1) ])
		ifTrue: [ varName := (varName , '2') ].
	
	varName := MocoSqlPostgresqlEscaping escapeName: varName.
	
	aBoolean ifFalse: [ str nextPutAll: 'NOT ' ].
	
	str
		nextPutAll: 'EXISTS (SELECT 1 FROM ';
		nextPutAll: (MocoSqlPostgresqlEscaping escapeName: (aMocoRdbTable name));
		nextPutAll: ' ';
		nextPutAll: varName;
		nextPutAll: ' WHERE ';
		nextPutAll: varName;
		nextPutAll: '.';
		nextPutAll: (MocoSqlPostgresqlEscaping escapeName: (aMocoRdbColumn name));
		nextPutAll: ' = ';
		nextPutAll: aString;
		nextPutAll: '.';
		nextPutAll: (MocoSqlPostgresqlEscaping escapeName: (aMocoRdbColumn2 name));
		nextPutAll: ')'.
	
	^ str contents
]

{ #category : 'private - processing' }
MocoRdbPostgresqlOclExclusiveAssociationTransformationRule >> generateInsertTrigger: aMocoOclRdbExclusiveAssociationCondition forTable: aMocoRdbTable [
	| trigger body first column |
	trigger := MocoSqlPostgresqlCreateTrigger new.
	
	trigger name: ((MocoNamingUtils toUpperSnakeCase: (aMocoOclRdbExclusiveAssociationCondition name)) , '_' , (aMocoRdbTable name) , '_INS');
		table: (aMocoRdbTable name);
		time: #BEFORE;
		event: #INSERT;
		granularity: #'EACH ROW'.
	
	body := String new writeStream.
	
	body
		nextPutAll: 'IF ('.
	
	(aMocoOclRdbExclusiveAssociationCondition referencingTables) with: (aMocoOclRdbExclusiveAssociationCondition referencingColumns) do: [ :t :c |
		((t first) == aMocoRdbTable) ifTrue: [ column := c first ]
	].
	
	first := true.
	
	(aMocoOclRdbExclusiveAssociationCondition referencingTables) with: (aMocoOclRdbExclusiveAssociationCondition referencingColumns) do: [ :t :c |
		((t first) == aMocoRdbTable) ifFalse: [
			body cr; nextPutAll: '  '.
			first ifFalse: [ body nextPutAll: 'OR ' ].
			body nextPutAll: (self generateExists: true clauseFor: (t first) andColumn: (c first) withReferenced: column andLabel: 'NEW').
			first := false
		]
	].

	body
	  cr;
		nextPutAll: ') THEN';
		cr;
		nextPutAll: '  RAISE EXCEPTION ';
		nextPutAll: (MocoSqlPostgresqlEscaping escapeLiteral: ('OCL constraint ' , (aMocoOclRdbExclusiveAssociationCondition name) , ' violated!'));
		nextPutAll: ';';
		cr;
		nextPutAll: 'END IF;';
		cr;
		nextPutAll: 'RETURN NEW;'.
	
	trigger body: (body contents).
	
	^ trigger
]

{ #category : 'private - processing' }
MocoRdbPostgresqlOclExclusiveAssociationTransformationRule >> generateInsertTriggers: aMocoOclRdbExclusiveAssociationCondition [
	| triggers |
	triggers := OrderedCollection new.
	
	((aMocoOclRdbExclusiveAssociationCondition referencingTables size) < 2) ifTrue: [ ^ triggers ].
	
	triggers addAll: (aMocoOclRdbExclusiveAssociationCondition referencingTables collect: [ :each | self generateInsertTrigger: aMocoOclRdbExclusiveAssociationCondition forTable: (each first) ] ).
	
	^ triggers
]

{ #category : 'private - processing' }
MocoRdbPostgresqlOclExclusiveAssociationTransformationRule >> generateSourceTrigger: aMocoOclRdbExclusiveAssociationCondition [
	| trigger body |
	trigger := MocoSqlPostgresqlCreateTrigger new.
	
	trigger name: (MocoNamingUtils toUpperSnakeCase: (aMocoOclRdbExclusiveAssociationCondition name));
		table: (aMocoOclRdbExclusiveAssociationCondition context name);
		time: #BEFORE;
		event: #'INSERT OR UPDATE';
		granularity: #'EACH ROW'.
	
	body := String new writeStream.
	
	body nextPutAll: 'IF NOT ('.
	
	aMocoOclRdbExclusiveAssociationCondition referencingTables do: [ :each |
		| str |
		
		((each size) > 1) ifTrue: [ self error: 'MocoRdbPostgresqlOclExclusiveAssociationTransformationRule cannot transform a constraint with overlapping associations.' ].
		
		str := String new writeStream.
		
		(each == (aMocoOclRdbExclusiveAssociationCondition referencingTables first))
			ifTrue: [ str nextPutAll: '('; cr; nextPutAll: '    ' ]
			ifFalse: [ str cr; nextPutAll: '  OR ('; cr; nextPutAll: '    ' ].
		
		(aMocoOclRdbExclusiveAssociationCondition referencingTables) with: (aMocoOclRdbExclusiveAssociationCondition referencingColumns) do: [ :t :c |
			str nextPutAll: (self generateExists: (t == each) clauseFor: (t first) andColumn: (c first) withReferenced: (aMocoOclRdbExclusiveAssociationCondition column) andLabel: 'NEW').
			(t == (aMocoOclRdbExclusiveAssociationCondition referencingTables last)) ifFalse: [ str cr; nextPutAll: '    AND ' ]
		].
		
		str nextPutAll: ')'.
		
		body nextPutAll: (str contents)
	].

	body
		cr;
		nextPutAll: ') THEN';
		cr;
		nextPutAll: '  RAISE EXCEPTION ';
		nextPutAll: (MocoSqlPostgresqlEscaping escapeLiteral: ('OCL constraint ' , (aMocoOclRdbExclusiveAssociationCondition name) , ' violated!'));
		nextPutAll: ';';
		cr;
		nextPutAll: 'END IF;';
		cr;
		nextPutAll: 'RETURN NEW;'.
	
	trigger body: (body contents).
	
	^ trigger
]

{ #category : 'private - processing' }
MocoRdbPostgresqlOclExclusiveAssociationTransformationRule >> generateUpdateTrigger: aMocoOclRdbExclusiveAssociationCondition forTable: aMocoRdbTable [
	| trigger body varName |
	trigger := MocoSqlPostgresqlCreateTrigger new.
	
	trigger name: ((MocoNamingUtils toUpperSnakeCase: (aMocoOclRdbExclusiveAssociationCondition name)) , '_' , (aMocoRdbTable name) , '_UPD_DEL');
		table: (aMocoRdbTable name);
		time: #AFTER;
		event: #'UPDATE OR DELETE'.
	
	body := String new writeStream.
	
	varName := MocoSqlPostgresqlEscaping escapeName: (MocoNamingUtils toShortName: (aMocoOclRdbExclusiveAssociationCondition context name)).
	
	body
	  nextPutAll: 'IF EXISTS (SELECT 1 FROM ';
		nextPutAll: (MocoSqlPostgresqlEscaping escapeName: (aMocoOclRdbExclusiveAssociationCondition context name));
		nextPutAll: ' ';
		nextPutAll: varName;
		nextPutAll: ' WHERE NOT ('.
	
	aMocoOclRdbExclusiveAssociationCondition referencingTables do: [ :each |
		(each == (aMocoOclRdbExclusiveAssociationCondition referencingTables first)) ifTrue: [ body nextPutAll: '(' ] ifFalse: [ body cr; nextPutAll: '  OR (' ].
		body cr; nextPutAll: '    '.

		(aMocoOclRdbExclusiveAssociationCondition referencingTables) with: (aMocoOclRdbExclusiveAssociationCondition referencingColumns) do: [ :t :c |
			body nextPutAll: (self generateExists: (t == each) clauseFor: (t first) andColumn: (c first) withReferenced: (aMocoOclRdbExclusiveAssociationCondition column) andLabel: varName).
			(t == (aMocoOclRdbExclusiveAssociationCondition referencingTables last)) ifFalse: [ body cr; nextPutAll: '    AND ' ]
		].
		
		body nextPutAll: ')'
	].

	body
	  cr;
		nextPutAll: ')) THEN';
		cr;
		nextPutAll: '  RAISE EXCEPTION ';
		nextPutAll: (MocoSqlPostgresqlEscaping escapeLiteral: ('OCL constraint ' , (aMocoOclRdbExclusiveAssociationCondition name) , ' violated!'));
		nextPutAll: ';';
		cr;
		nextPutAll: 'END IF;';
		cr;
		nextPutAll: 'RETURN NULL;'.
	
	trigger body: (body contents).
	
	^ trigger
]

{ #category : 'private - processing' }
MocoRdbPostgresqlOclExclusiveAssociationTransformationRule >> generateUpdateTriggers: aMocoOclRdbExclusiveAssociationCondition [
	^ (aMocoOclRdbExclusiveAssociationCondition referencingTables collect: [ :each | self generateUpdateTrigger: aMocoOclRdbExclusiveAssociationCondition forTable: (each first) ] )
]
