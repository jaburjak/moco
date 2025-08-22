"
Transforms OCL constraints for exclusive phase associations to CREATE TRIGGER statements.
"
Class {
	#name : 'MocoRdbMssqlOclExclusiveAssociationTransformationRule',
	#superclass : 'MocoTransformationRule',
	#category : 'Moco-D2SMssql-Rule',
	#package : 'Moco-D2SMssql',
	#tag : 'Rule'
}

{ #category : 'transforming' }
MocoRdbMssqlOclExclusiveAssociationTransformationRule >> execute [
	| ocls |
	ocls := engine input
		selectElementsOfKind: MocoOclRdbExclusiveAssociationCondition
		notGuarded: #MocoRdbMssqlOclExclusiveAssociationTransformationRule.
	
	ocls do: [ :each |
		| triggers |
		triggers := OrderedCollection new.
		
		triggers
			add: (self generateSourceTrigger: each);
			addAll: (self generateInsertTriggers: each);
			addAll: (self generateUpdateTriggers: each).
		
		triggers do: [ :e | engine addOutputElement: e withSource: each ].
		engine input guard: each with: #MocoRdbMssqlOclExclusiveAssociationTransformationRule
	]
]

{ #category : 'private - processing' }
MocoRdbMssqlOclExclusiveAssociationTransformationRule >> generateExists: aBoolean clauseFor: aMocoRdbTable andColumn: aMocoRdbColumn withReferenced: aMocoRdbColumn2 andLabel: aString [
	| str varName |
	str := String new writeStream.
	
	varName := MocoNamingUtils toShortName: (aMocoRdbTable name).
	varName := MocoUniqueNameGenerator at: [ :n | n = aString ] seed: varName.
	varName := MocoSqlMssqlEscaping escapeName: varName.
	
	aBoolean ifFalse: [ str nextPutAll: 'NOT ' ].
	
	str
		nextPutAll: 'EXISTS (SELECT 1 FROM ';
		nextPutAll: (MocoSqlMssqlEscaping escapeName: (aMocoRdbTable name));
		nextPutAll: ' ';
		nextPutAll: varName;
		nextPutAll: ' WHERE ';
		nextPutAll: varName;
		nextPutAll: '.';
		nextPutAll: (MocoSqlMssqlEscaping escapeName: (aMocoRdbColumn name));
		nextPutAll: ' = ';
		nextPutAll: (MocoSqlMssqlEscaping escapeName: aString);
		nextPutAll: '.';
		nextPutAll: (MocoSqlMssqlEscaping escapeName: (aMocoRdbColumn2 name));
		nextPutAll: ')'.
	
	^ str contents
]

{ #category : 'private - processing' }
MocoRdbMssqlOclExclusiveAssociationTransformationRule >> generateInsertTrigger: aMocoOclRdbExclusiveAssociationCondition forTable: aMocoRdbTable [
	| trigger body first column |
	trigger := MocoSqlMssqlCreateTrigger new.
	
	trigger name: ((MocoNamingUtils toUpperSnakeCase: (aMocoOclRdbExclusiveAssociationCondition name)) , '_' , (aMocoRdbTable name) , '_INS');
		table: (aMocoRdbTable name);
		event: #INSERT.
	
	body := String new writeStream.
	
	body nextPutAll: 'IF '.
	
	(aMocoOclRdbExclusiveAssociationCondition referencingTables) with: (aMocoOclRdbExclusiveAssociationCondition referencingColumns) do: [ :t :c |
		((t first) = aMocoRdbTable) ifTrue: [ column := c first ]
	].
	
	first := true.
	
	(aMocoOclRdbExclusiveAssociationCondition referencingTables) with: (aMocoOclRdbExclusiveAssociationCondition referencingColumns) do: [ :t :c |
		| varName |
		varName := MocoNamingUtils toShortName: (t first name).
		varName := MocoUniqueNameGenerator at: [ :n | n = 'i' ] seed: varName.
		varName := MocoSqlMssqlEscaping escapeName: varName.
		
		first ifFalse: [ body cr; nextPutAll: '  OR ' ].
		
		body
			nextPutAll: 'EXISTS (SELECT 1 FROM [inserted] [i] JOIN ';
			nextPutAll: (MocoSqlMssqlEscaping escapeName: (t first name));
			nextPutAll: ' ';
			nextPutAll: varName;
			nextPutAll: ' ON ';
			nextPutAll: varName;
			nextPutAll: '.';
			nextPutAll: (MocoSqlMssqlEscaping escapeName: (c first name));
			nextPutAll: ' = [i].';
			nextPutAll: (MocoSqlMssqlEscaping escapeName: (column name));
			nextPutAll: ')'.
		
		first := false
	].
	
	body
		cr;
		nextPutAll: 'BEGIN';
		cr;
		nextPutAll: '  THROW 5000, ';
		nextPutAll: (MocoSqlMssqlEscaping escapeLiteral: ('OCL constraint ' , (aMocoOclRdbExclusiveAssociationCondition name) , ' violated!'));
		nextPutAll: ', 2;';
		cr;
		nextPutAll: 'END;'.
	
	trigger body: (body contents).
	
	^ trigger
]

{ #category : 'private - processing' }
MocoRdbMssqlOclExclusiveAssociationTransformationRule >> generateInsertTriggers: aMocoOclRdbExclusiveAssociationCondition [
	| triggers |
	triggers := OrderedCollection new.
	
	((aMocoOclRdbExclusiveAssociationCondition referencingTables size) < 2) ifTrue: [ ^ triggers ].
	
	triggers addAll: (aMocoOclRdbExclusiveAssociationCondition referencingTables collect: [ :each | self generateInsertTrigger: aMocoOclRdbExclusiveAssociationCondition forTable: (each first) ] ).
	
	^ triggers
]

{ #category : 'private - processing' }
MocoRdbMssqlOclExclusiveAssociationTransformationRule >> generateSourceTrigger: aMocoOclRdbExclusiveAssociationCondition [
	| trigger body |
	trigger := MocoSqlMssqlCreateTrigger new.
	
	trigger name: (MocoNamingUtils toUpperSnakeCase: (aMocoOclRdbExclusiveAssociationCondition name));
		table: (aMocoOclRdbExclusiveAssociationCondition context name);
		event: #'INSERT, UPDATE'.
	
	body := String new writeStream.
	
	body nextPutAll: 'IF EXISTS (SELECT 1 FROM [inserted] [i] WHERE NOT ('.
	
	aMocoOclRdbExclusiveAssociationCondition referencingTables do: [ :each |
		| str |
		
		((each size) > 1) ifTrue: [ self error: 'MocoRdbMssqlOclExclusiveAssociationTransformationRule cannot transform a constraint with overlapping associations.' ].
		
		str := String new writeStream.
		
		(each == (aMocoOclRdbExclusiveAssociationCondition referencingTables first))
			ifTrue: [ str cr; nextPutAll: '  (' ]
			ifFalse: [ str cr; nextPutAll: '  OR (' ].
		
		(aMocoOclRdbExclusiveAssociationCondition referencingTables) with: (aMocoOclRdbExclusiveAssociationCondition referencingColumns) do: [ :t :c |
			str nextPutAll: (self generateExists: (t == each) clauseFor: (t first) andColumn: (c first) withReferenced: (aMocoOclRdbExclusiveAssociationCondition column) andLabel: 'i').
			(t == (aMocoOclRdbExclusiveAssociationCondition referencingTables last)) ifFalse: [ str cr; nextPutAll: '    AND ' ]
		].
		
		str nextPutAll: ')'.
		
		body nextPutAll: (str contents)
	].

	body
		cr;
		nextPutAll: ')) BEGIN';
		cr;
		nextPutAll: '  THROW 5000, ';
		nextPutAll: (MocoSqlMssqlEscaping escapeLiteral: ('OCL constraint ' , (aMocoOclRdbExclusiveAssociationCondition name) , ' violated!'));
		nextPutAll: ', 1;';
		cr;
		nextPutAll: 'END;'.
	
	trigger body: (body contents).
	
	^ trigger
]

{ #category : 'private - processing' }
MocoRdbMssqlOclExclusiveAssociationTransformationRule >> generateUpdateTrigger: aMocoOclRdbExclusiveAssociationCondition forTable: aMocoRdbTable [
	| trigger body varName |
	trigger := MocoSqlMssqlCreateTrigger new.
	
	trigger name: ((MocoNamingUtils toUpperSnakeCase: (aMocoOclRdbExclusiveAssociationCondition name)) , '_' , (aMocoRdbTable name) , '_UPD_DEL');
		table: (aMocoRdbTable name);
		event: #'UPDATE, DELETE'.
	
	body := String new writeStream.
	
	varName := MocoNamingUtils toShortName: (aMocoOclRdbExclusiveAssociationCondition context name).
	
	body
		nextPutAll: 'IF EXISTS (SELECT 1 FROM ';
		nextPutAll: (MocoSqlMssqlEscaping escapeName: (aMocoOclRdbExclusiveAssociationCondition context name));
		nextPutAll: ' ';
		nextPutAll: (MocoSqlMssqlEscaping escapeName: varName);
		nextPutAll: ' WHERE NOT ('.
	
	aMocoOclRdbExclusiveAssociationCondition referencingTables do: [ :each |
		body cr; nextPutAll: '  '.
		(each == (aMocoOclRdbExclusiveAssociationCondition referencingTables first)) ifFalse: [ body nextPutAll: 'OR ' ].
		body nextPutAll: '('.

		(aMocoOclRdbExclusiveAssociationCondition referencingTables) with: (aMocoOclRdbExclusiveAssociationCondition referencingColumns) do: [ :t :c |
			body nextPutAll: (self generateExists: (t == each) clauseFor: (t first) andColumn: (c first) withReferenced: (aMocoOclRdbExclusiveAssociationCondition column) andLabel: varName).
			(t == (aMocoOclRdbExclusiveAssociationCondition referencingTables last)) ifFalse: [ body cr; nextPutAll: '    AND ' ]
		].
		
		body nextPutAll: ')'
	].

	body
		nextPutAll: ')';
		cr;
		nextPutAll: ') BEGIN';
		cr;
		nextPutAll: '  THROW 5000, ';
		nextPutAll: (MocoSqlMssqlEscaping escapeLiteral: ('OCL constraint ' , (aMocoOclRdbExclusiveAssociationCondition name) , ' violated!'));
		nextPutAll: ', 3;';
		cr;
		nextPutAll: 'END;'.
	
	trigger body: (body contents).
	
	^ trigger
]

{ #category : 'private - processing' }
MocoRdbMssqlOclExclusiveAssociationTransformationRule >> generateUpdateTriggers: aMocoOclRdbExclusiveAssociationCondition [
	^ (aMocoOclRdbExclusiveAssociationCondition referencingTables collect: [ :each | self generateUpdateTrigger: aMocoOclRdbExclusiveAssociationCondition forTable: (each first) ] )
]
