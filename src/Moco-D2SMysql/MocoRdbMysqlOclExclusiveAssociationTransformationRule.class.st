"
Transforms OCL constraints for exclusive phase associations to CREATE TRIGGER and CREATE PROCEDURE statements in a MySQL database.
"
Class {
	#name : 'MocoRdbMysqlOclExclusiveAssociationTransformationRule',
	#superclass : 'MocoTransformationRule',
	#category : 'Moco-D2SMysql-Rule',
	#package : 'Moco-D2SMysql',
	#tag : 'Rule'
}

{ #category : 'transforming' }
MocoRdbMysqlOclExclusiveAssociationTransformationRule >> execute [
	| ocls |
	ocls := engine input
		selectElementsOfKind: MocoOclRdbExclusiveAssociationCondition
		notGuarded: #MocoRdbMysqlOclExclusiveAssociationTransformationRule.
	
	ocls do: [ :each |
		| triggers |
		triggers := OrderedCollection new.
		
		triggers
			add: (self generateSourceProcedure: each);
			addAll: (self generateInsertTriggers: each);
			addAll: (self generateUpdateTriggers: each);
			addAll: (self generateDeleteTriggers: each).
		
		triggers do: [ :e | engine addOutputElement: e withSource: each ].
		engine input guard: each with: #MocoRdbMysqlOclExclusiveAssociationTransformationRule
	]
]

{ #category : 'private - processing' }
MocoRdbMysqlOclExclusiveAssociationTransformationRule >> generateDeleteTrigger: aMocoOclRdbExclusiveAssociationCondition forTable: aMocoRdbTable [
	| column trigger body |
	(aMocoOclRdbExclusiveAssociationCondition referencingTables) with: (aMocoOclRdbExclusiveAssociationCondition referencingColumns) do: [ :t :c | (t identityIncludes: aMocoRdbTable) ifTrue: [ column := (c first) ] ].

	trigger := MocoSqlMysqlCreateTrigger new.
	
	trigger name: ((MocoNamingUtils toUpperSnakeCase: (aMocoOclRdbExclusiveAssociationCondition name)) , '_' , (aMocoRdbTable name) , '_DEL');
		table: (aMocoRdbTable name);
		time: #AFTER;
		event: #DELETE.
	
	body := String new writeStream.
	
	body
		nextPutAll: (self generateSumVariableFor: aMocoOclRdbExclusiveAssociationCondition forTable: aMocoRdbTable withReferencedColumn: column andIndent: '').

	body
		cr;
		nextPutAll: 'IF @o_count <> 1 THEN';
		cr;
		nextPutAll: '  SIGNAL SQLSTATE ''45000'' SET MESSAGE_TEXT = ';
		nextPutAll: (MocoSqlMysqlEscaping escapeLiteral: ('OCL constraint ' , (aMocoOclRdbExclusiveAssociationCondition name) , ' violated!'));
		nextPutAll: ';';
		cr;
		nextPutAll: 'END IF;'.
	
	trigger body: (body contents).
	
	^ trigger
]

{ #category : 'private - processing' }
MocoRdbMysqlOclExclusiveAssociationTransformationRule >> generateDeleteTriggers: aMocoOclRdbExclusiveAssociationCondition [
	^ (aMocoOclRdbExclusiveAssociationCondition referencingTables collect: [ :each | self generateDeleteTrigger: aMocoOclRdbExclusiveAssociationCondition forTable: (each first) ] )
]

{ #category : 'private - processing' }
MocoRdbMysqlOclExclusiveAssociationTransformationRule >> generateExists: aBoolean clauseFor: aMocoRdbTable andColumn: aMocoRdbColumn withReferenced: aMocoRdbColumn2 andLabel: aString [
	| str varName |
	str := String new writeStream.
	
	varName := MocoNamingUtils toShortName: (aMocoRdbTable name).
	
	((aString isNotEmpty) and: [ (((aString first = $`) and: [ aString last = $` ]) and: [ varName = ((aString allButFirst: 1) allButLast: 1) ]) ])
		ifTrue: [ varName := (varName , '2') ].
	
	varName := MocoSqlMysqlEscaping escapeName: varName.
	
	aBoolean ifFalse: [ str nextPutAll: 'NOT ' ].
	
	str
		nextPutAll: 'EXISTS (SELECT 1 FROM ';
		nextPutAll: (MocoSqlMysqlEscaping escapeName: (aMocoRdbTable name));
		nextPutAll: ' ';
		nextPutAll: varName;
		nextPutAll: ' WHERE ';
		nextPutAll: varName;
		nextPutAll: '.';
		nextPutAll: (MocoSqlMysqlEscaping escapeName: (aMocoRdbColumn name));
		nextPutAll: ' = '.
	
	aString ifNotEmpty: [ str nextPutAll: aString; nextPutAll: '.' ].

	str
		nextPutAll: (MocoSqlMysqlEscaping escapeName: (aMocoRdbColumn2 name));
		nextPutAll: ')'.
	
	^ str contents
]

{ #category : 'private - processing' }
MocoRdbMysqlOclExclusiveAssociationTransformationRule >> generateInsertTrigger: aMocoOclRdbExclusiveAssociationCondition forTable: aMocoRdbTable [
	| trigger body first column |
	trigger := MocoSqlMysqlCreateTrigger new.
	
	trigger name: ((MocoNamingUtils toUpperSnakeCase: (aMocoOclRdbExclusiveAssociationCondition name)) , '_' , (aMocoRdbTable name) , '_INS');
		table: (aMocoRdbTable name);
		time: #BEFORE;
		event: #INSERT.
	
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
		nextPutAll: '  SIGNAL SQLSTATE ''45000'' SET MESSAGE_TEXT = ';
		nextPutAll: (MocoSqlMysqlEscaping escapeLiteral: ('OCL constraint ' , (aMocoOclRdbExclusiveAssociationCondition name) , ' violated!'));
		nextPutAll: ';';
		cr;
		nextPutAll: 'END IF;'.
	
	trigger body: (body contents).
	
	^ trigger
]

{ #category : 'private - processing' }
MocoRdbMysqlOclExclusiveAssociationTransformationRule >> generateInsertTriggers: aMocoOclRdbExclusiveAssociationCondition [
	| triggers |
	triggers := OrderedCollection new.
	
	((aMocoOclRdbExclusiveAssociationCondition referencingTables size) < 2) ifTrue: [ ^ triggers ].
	
	triggers addAll: (aMocoOclRdbExclusiveAssociationCondition referencingTables collect: [ :each | self generateInsertTrigger: aMocoOclRdbExclusiveAssociationCondition forTable: (each first) ] ).
	
	^ triggers
]

{ #category : 'private - processing' }
MocoRdbMysqlOclExclusiveAssociationTransformationRule >> generateSourceProcedure: aMocoOclRdbExclusiveAssociationCondition [
	| procedure input body |
	procedure := MocoSqlMysqlCreateProcedure new.
	
	procedure name: (MocoNamingUtils toUpperSnakeCase: (aMocoOclRdbExclusiveAssociationCondition name));
		comment: 'call after INSERT or UPDATE on ' , (MocoSqlMysqlEscaping escapeName: aMocoOclRdbExclusiveAssociationCondition context name) , ' if no related record is going to be inserted'.
	
	aMocoOclRdbExclusiveAssociationCondition column type accept: (MocoSqlMysqlDataTypeResolver instance).
	
	input := MocoSqlMysqlCreateProcedureInput new name: (aMocoOclRdbExclusiveAssociationCondition column name); type: (MocoSqlMysqlDataTypeResolver instance typeDeclaration); yourself.
	
	procedure inputs add: input.
	
	body := String new writeStream.
	
	body nextPutAll: 'IF NOT ('.
	
	aMocoOclRdbExclusiveAssociationCondition referencingTables do: [ :each |
		| str |
		
		((each size) > 1) ifTrue: [ self error: 'MocoRdbMysqlOclExclusiveAssociationTransformationRule cannot transform a constraint with overlapping associations.' ].
		
		str := String new writeStream.
		
		(each == (aMocoOclRdbExclusiveAssociationCondition referencingTables first))
			ifTrue: [ str nextPutAll: '('; cr; nextPutAll: '    ' ]
			ifFalse: [ str cr; nextPutAll: '  OR ('; cr; nextPutAll: '    ' ].
		
		(aMocoOclRdbExclusiveAssociationCondition referencingTables) with: (aMocoOclRdbExclusiveAssociationCondition referencingColumns) do: [ :t :c |
			str nextPutAll: (self generateExists: (t == each) clauseFor: (t first) andColumn: (c first) withReferenced: (aMocoOclRdbExclusiveAssociationCondition column) andLabel: '').
			(t == (aMocoOclRdbExclusiveAssociationCondition referencingTables last)) ifFalse: [ str cr; nextPutAll: '    AND ' ]
		].
		
		str nextPutAll: ')'.
		
		body nextPutAll: (str contents)
	].

	body
		cr;
		nextPutAll: ') THEN';
		cr;
		nextPutAll: '  SIGNAL SQLSTATE ''45000'' SET MESSAGE_TEXT = ';
		nextPutAll: (MocoSqlMysqlEscaping escapeLiteral: ('OCL constraint ' , (aMocoOclRdbExclusiveAssociationCondition name) , ' violated!'));
		nextPutAll: ';';
		cr;
		nextPutAll: 'END IF;'.
	
	procedure body: (body contents).
	
	^ procedure
]

{ #category : 'private - processing' }
MocoRdbMysqlOclExclusiveAssociationTransformationRule >> generateSumVariableFor: aMocoOclRdbExclusiveAssociationCondition forTable: aMocoRdbTable withReferencedColumn: aMocoRdbColumn andIndent: aString [
	| body sum |
	body := String new writeStream.
	
	body
		nextPutAll: aString;
		nextPutAll: 'SET @o_count := (SELECT'.
	
	sum := OrderedCollection new.
	
	(aMocoOclRdbExclusiveAssociationCondition referencingTables) with: (aMocoOclRdbExclusiveAssociationCondition referencingColumns) do: [ :t :c |
		(t identityIncludes: aMocoRdbTable) ifFalse: [
			| str varName |
			str := String new writeStream.
			varName := MocoSqlMysqlEscaping escapeName: (MocoNamingUtils toShortName: (t first name)).
			str
			   nextPutAll: aString;
				nextPutAll: '  (SELECT COUNT(*) FROM ';
				nextPutAll: (MocoSqlMysqlEscaping escapeName: (t first name));
				nextPutAll: ' ';
				nextPutAll: varName;
				nextPutAll: ' WHERE ';
				nextPutAll: varName;
				nextPutAll: '.';
				nextPutAll: (MocoSqlMysqlEscaping escapeName: (c first name));
				nextPutAll: ' = OLD.';
				nextPutAll: (MocoSqlMysqlEscaping escapeName: aMocoRdbColumn name);
				nextPutAll: ')'.
			sum add: (str contents).
		]
	].

	sum ifEmpty: [ body nextPutAll: '0' ]
		ifNotEmpty: [ body cr; nextPutAll: ((' +' , String cr) join: sum) ].

	body nextPutAll: ');'.
	
	^ (body contents)
]

{ #category : 'private - processing' }
MocoRdbMysqlOclExclusiveAssociationTransformationRule >> generateUpdateTrigger: aMocoOclRdbExclusiveAssociationCondition forTable: aMocoRdbTable [
	| column trigger body |
	(aMocoOclRdbExclusiveAssociationCondition referencingTables) with: (aMocoOclRdbExclusiveAssociationCondition referencingColumns) do: [ :t :c | (t identityIncludes: aMocoRdbTable) ifTrue: [ column := (c first) ] ].

	trigger := MocoSqlMysqlCreateTrigger new.
	
	trigger name: ((MocoNamingUtils toUpperSnakeCase: (aMocoOclRdbExclusiveAssociationCondition name)) , '_' , (aMocoRdbTable name) , '_UPD');
		table: (aMocoRdbTable name);
		time: #AFTER;
		event: #UPDATE.
	
	body := String new writeStream.
	
	body
		nextPutAll: 'IF OLD.';
		nextPutAll: (MocoSqlMysqlEscaping escapeName: (column name));
		nextPutAll: ' <> ';
		nextPutAll: (MocoSqlMysqlEscaping escapeName: (column name));
		nextPutAll: ' THEN';
		cr;
		nextPutAll: (self generateSumVariableFor: aMocoOclRdbExclusiveAssociationCondition forTable: aMocoRdbTable withReferencedColumn: column andIndent: '  ').

	body
		cr;
		nextPutAll: '  IF @o_count <> 1'.
	
	((aMocoOclRdbExclusiveAssociationCondition referencingTables size) > 1)
		ifTrue: [ body nextPutAll: ' OR' ].

	(aMocoOclRdbExclusiveAssociationCondition referencingTables) with: (aMocoOclRdbExclusiveAssociationCondition referencingColumns) do: [ :t :c |
		(t identityIncludes: aMocoRdbTable) ifFalse: [
			body cr; nextPutAll: '    ';
				nextPutAll: (self generateExists: true clauseFor: (t first) andColumn: (c first) withReferenced: (aMocoOclRdbExclusiveAssociationCondition column) andLabel: 'NEW')
		]
	].

	body
		cr;
		nextPutAll: '  THEN';
		cr;
		nextPutAll: '    SIGNAL SQLSTATE ''45000'' SET MESSAGE_TEXT = ';
		nextPutAll: (MocoSqlMysqlEscaping escapeLiteral: ('OCL constraint ' , (aMocoOclRdbExclusiveAssociationCondition name) , ' violated!'));
		nextPutAll: ';';
		cr;
		nextPutAll: '  END IF;';
		cr;
		nextPutAll: 'END IF;'.
	
	trigger body: (body contents).
	
	^ trigger
]

{ #category : 'private - processing' }
MocoRdbMysqlOclExclusiveAssociationTransformationRule >> generateUpdateTriggers: aMocoOclRdbExclusiveAssociationCondition [
	^ (aMocoOclRdbExclusiveAssociationCondition referencingTables collect: [ :each | self generateUpdateTrigger: aMocoOclRdbExclusiveAssociationCondition forTable: (each first) ] )
]

{ #category : 'accessing' }
MocoRdbMysqlOclExclusiveAssociationTransformationRule >> priority [
	^ 80
]
