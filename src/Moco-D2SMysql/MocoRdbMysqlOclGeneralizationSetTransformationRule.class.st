"
Transforms the generalization set OCL constraint into a series of TRIGGER definitions.
"
Class {
	#name : 'MocoRdbMysqlOclGeneralizationSetTransformationRule',
	#superclass : 'MocoTransformationRule',
	#category : 'Moco-D2SMysql-Rule',
	#package : 'Moco-D2SMysql',
	#tag : 'Rule'
}

{ #category : 'transforming' }
MocoRdbMysqlOclGeneralizationSetTransformationRule >> execute [
	| ocls |
	ocls := engine input
		selectElementsOfKind: MocoOclRdbGeneralizationSetConstraint
		notGuarded: #MocoRdbMysqlOclGeneralizationSetTransformationRule.

	ocls do: [ :each |
		self generateSuperclassProcedure: each;
			generateSubclassInsertTriggers: each;
			generateSubclassUpdateTriggers: each;
			generateSubclassDeleteProcedure: each.
		
		engine input guard: each with: #MocoRdbMysqlOclGeneralizationSetTransformationRule
	]
]

{ #category : 'private - processing' }
MocoRdbMysqlOclGeneralizationSetTransformationRule >> findValuesForTable: aMocoRdbTable in: aMocoOclRdbGeneralizationSetTransformationConstraint [
	| values |
	values := OrderedCollection new.

	aMocoOclRdbGeneralizationSetTransformationConstraint values with: (aMocoOclRdbGeneralizationSetTransformationConstraint configurations) do: [ :v :c |
		aMocoOclRdbGeneralizationSetTransformationConstraint tables with: c do: [ :t :e |
			e ifTrue: [
				(t first == aMocoRdbTable) ifTrue: [
					values add: v
				]
			]
		]
	].

	^ values
]

{ #category : 'private - processing' }
MocoRdbMysqlOclGeneralizationSetTransformationRule >> generateSubclassDeleteProcedure: aMocoOclRdbGeneralizationSetTransformationConstraint [
	| procedure body table in discr |
	procedure := MocoSqlMysqlCreateProcedure new.
	
	in := aMocoOclRdbGeneralizationSetTransformationConstraint keyColumn name.

	procedure name: (MocoNamingUtils toUpperSnakeCase: (aMocoOclRdbGeneralizationSetTransformationConstraint name)) , '_DEL'.
	procedure inputs add: (MocoSqlMysqlCreateProcedureInput new name: in; type: (self toTypeDeclaration: aMocoOclRdbGeneralizationSetTransformationConstraint keyColumn); yourself).
	
	in := MocoSqlMysqlEscaping escapeName: in.
	
	body := String new writeStream.
	table := MocoSqlMysqlEscaping escapeName: (MocoNamingUtils toShortName: (aMocoOclRdbGeneralizationSetTransformationConstraint context name)).
	
	body nextPutAll: 'IF EXISTS (';
		cr;
		nextPutAll: '  SELECT 1 FROM ';
		nextPutAll: (MocoSqlMysqlEscaping escapeName: (aMocoOclRdbGeneralizationSetTransformationConstraint context name));
		nextPutAll: ' ';
		nextPutAll: table;
		nextPutAll: ' WHERE ';
		nextPutAll: table;
		nextPutAll: '.';
		nextPutAll: (MocoSqlMysqlEscaping escapeName: (aMocoOclRdbGeneralizationSetTransformationConstraint keyColumn name));
		nextPutAll: ' = ';
		nextPutAll: in.

	discr := ''.
	
	aMocoOclRdbGeneralizationSetTransformationConstraint values with: (aMocoOclRdbGeneralizationSetTransformationConstraint configurations) do: [ :v :c |
		| sup |
		sup := true.

		aMocoOclRdbGeneralizationSetTransformationConstraint tables with: c do: [ :t :e |
			((t == (aMocoOclRdbGeneralizationSetTransformationConstraint context)) and: (e not)) ifTrue: [ sup := false ].
			(((t == (aMocoOclRdbGeneralizationSetTransformationConstraint context)) not) and: e) ifTrue: [ sup := false ]
		].

		sup ifTrue: [ discr := v ]
	].

	discr ifNotEmpty: [
		body nextPutAll: ' AND ';
			nextPutAll: table;
			nextPutAll: '.';
			nextPutAll: (MocoSqlMysqlEscaping escapeName: (aMocoOclRdbGeneralizationSetTransformationConstraint discriminatorColumn name));
			nextPutAll: ' <> ';
			nextPutAll: (MocoSqlMysqlEscaping escapeLiteral: discr)
	].

	body cr;
		nextPutAll: ') THEN';
		cr;
		nextPutAll: '  SIGNAL SQLSTATE ''45000'' SET MESSAGE_TEXT = ';
		nextPutAll: (MocoSqlMysqlEscaping escapeLiteral: ('OCL constraint ' , (aMocoOclRdbGeneralizationSetTransformationConstraint name) , ' violated!'));
		nextPutAll: ';';
		cr;
		nextPutAll: 'END IF;'.

	procedure body: (body contents);
		comment: 'call after DELETE on ' , (' or ' join: (aMocoOclRdbGeneralizationSetTransformationConstraint tables reject: [ :t | (t first) == (aMocoOclRdbGeneralizationSetTransformationConstraint context) ] thenCollect: [ :t | MocoSqlMysqlEscaping escapeName: (t first name) ])).

	engine addOutputElement: procedure withSource: aMocoOclRdbGeneralizationSetTransformationConstraint
]

{ #category : 'private - processing' }
MocoRdbMysqlOclGeneralizationSetTransformationRule >> generateSubclassInsertTrigger: aMocoOclRdbGeneralizationSetTransformationConstraint forTable: aMocoRdbTable withColumn: aMocoRdbColumn [
	| trigger body varName discr values |
	trigger := MocoSqlMysqlCreateTrigger new.
	
	trigger name: ((MocoNamingUtils toUpperSnakeCase: (aMocoOclRdbGeneralizationSetTransformationConstraint name)) , '_' , (aMocoRdbTable name) , '_INS');
		table: (aMocoRdbTable name);
		time: #BEFORE;
		event: #INSERT.
		
	body := String new writeStream.
	
	discr := MocoSqlMysqlEscaping escapeName: (aMocoOclRdbGeneralizationSetTransformationConstraint discriminatorColumn name).
	varName := MocoSqlMysqlEscaping escapeName: (MocoNamingUtils toShortName: (aMocoOclRdbGeneralizationSetTransformationConstraint context name)).

	values := (self findValuesForTable: aMocoRdbTable in: aMocoOclRdbGeneralizationSetTransformationConstraint) collect: [ :v | varName , '.' , discr , ' = ' , (MocoSqlMysqlEscaping escapeLiteral: v) ].
	
	((values size) > 1)
		ifTrue: [ values := '(' , (' OR ' join: values) , ')' ]
		ifFalse: [ values := ' OR ' join: values ].
	
	body
		nextPutAll: 'IF NOT EXISTS (';
		cr;
		nextPutAll: '  SELECT 1 FROM ';
		nextPutAll: (MocoSqlMysqlEscaping escapeName: (aMocoOclRdbGeneralizationSetTransformationConstraint context name));
		nextPutAll: ' ';
		nextPutAll: varName;
		nextPutAll: ' WHERE ';
		nextPutAll: varName;
		nextPutAll: '.';
		nextPutAll: (MocoSqlMysqlEscaping escapeName: (aMocoOclRdbGeneralizationSetTransformationConstraint keyColumn name));
		nextPutAll: ' = NEW.';
		nextPutAll: (MocoSqlMysqlEscaping escapeName: (aMocoRdbColumn name));
		cr;
		nextPutAll: '  AND ';
		nextPutAll: values;
		cr;
		nextPutAll: ') THEN';
		cr;
		nextPutAll: '  SIGNAL SQLSTATE ''45000'' SET MESSAGE_TEXT = ';
		nextPutAll: (MocoSqlMysqlEscaping escapeLiteral: ('OCL constraint ' , (aMocoOclRdbGeneralizationSetTransformationConstraint name) , ' violated!'));
		nextPutAll: ';';
		cr;
		nextPutAll: 'END IF;'.
	
	trigger body: (body contents).
	
	^ trigger
]

{ #category : 'private - processing' }
MocoRdbMysqlOclGeneralizationSetTransformationRule >> generateSubclassInsertTriggers: aMocoOclRdbGeneralizationSetTransformationConstraint [
	aMocoOclRdbGeneralizationSetTransformationConstraint tables collect: [ :each |
		| trigger |
		trigger := self generateSubclassInsertTrigger: aMocoOclRdbGeneralizationSetTransformationConstraint forTable: (each first) withColumn: (each last).
		
		engine addOutputElement: trigger withSource: aMocoOclRdbGeneralizationSetTransformationConstraint
	]
]

{ #category : 'private - processing' }
MocoRdbMysqlOclGeneralizationSetTransformationRule >> generateSubclassUpdateTrigger: aMocoOclRdbGeneralizationSetTransformationConstraint forTable: aMocoRdbTable withColumn: aMocoRdbColumn [
	| trigger body varName |
	trigger := MocoSqlMysqlCreateTrigger new.
	
	trigger name: ((MocoNamingUtils toUpperSnakeCase: (aMocoOclRdbGeneralizationSetTransformationConstraint name)) , '_' , (aMocoRdbTable name) , '_UPD');
		table: (aMocoRdbTable name);
		time: #BEFORE;
		event: #UPDATE.
		
	body := String new writeStream.
	
	varName := MocoSqlMysqlEscaping escapeName: (MocoNamingUtils toShortName: (aMocoOclRdbGeneralizationSetTransformationConstraint context name)).
	
	body
		nextPutAll: 'IF OLD.';
		nextPutAll: (MocoSqlMysqlEscaping escapeName: (aMocoRdbColumn name));
		nextPutAll: ' <> NEW.';
		nextPutAll: (MocoSqlMysqlEscaping escapeName: (aMocoRdbColumn name));
		nextPutAll: ' AND ';
		cr;
		nextPutAll: '  EXISTS (SELECT 1 FROM ';
		nextPutAll: (MocoSqlMysqlEscaping escapeName: (aMocoOclRdbGeneralizationSetTransformationConstraint context name));
		nextPutAll: ' ';
		nextPutAll: varName;
		nextPutAll: ' WHERE ';
		nextPutAll: varName;
		nextPutAll: '.';
		nextPutAll: (MocoSqlMysqlEscaping escapeName: (aMocoOclRdbGeneralizationSetTransformationConstraint keyColumn name));
		nextPutAll: ' = OLD.';
		nextPutAll: (MocoSqlMysqlEscaping escapeName: (aMocoRdbColumn name));
		nextPutAll: ' OR ';
		nextPutAll: varName;
		nextPutAll: '.';
		nextPutAll: (MocoSqlMysqlEscaping escapeName: (aMocoOclRdbGeneralizationSetTransformationConstraint keyColumn name));
		nextPutAll: ' = NEW.';
		nextPutAll: (MocoSqlMysqlEscaping escapeName: (aMocoRdbColumn name));
		nextPutAll: ')';
		cr;
		nextPutAll: 'THEN';
		cr;
		nextPutAll: '  SIGNAL SQLSTATE ''45000'' SET MESSAGE_TEXT = ';
		nextPutAll: (MocoSqlMysqlEscaping escapeLiteral: ('OCL constraint ' , (aMocoOclRdbGeneralizationSetTransformationConstraint name) , ' violated!'));
		nextPutAll: ';';
		cr;
		nextPutAll: 'END IF;'.
	
	trigger body: (body contents).
	
	^ trigger
]

{ #category : 'private - processing' }
MocoRdbMysqlOclGeneralizationSetTransformationRule >> generateSubclassUpdateTriggers: aMocoOclRdbGeneralizationSetTransformationConstraint [
	aMocoOclRdbGeneralizationSetTransformationConstraint tables collect: [ :each |
		| trigger |
		trigger := self generateSubclassUpdateTrigger: aMocoOclRdbGeneralizationSetTransformationConstraint forTable: (each first) withColumn: (each last).
		
		engine addOutputElement: trigger withSource: aMocoOclRdbGeneralizationSetTransformationConstraint
	]
]

{ #category : 'private - processing' }
MocoRdbMysqlOclGeneralizationSetTransformationRule >> generateSuperclassProcedure: aMocoOclRdbGeneralizationSetTransformationConstraint [
	| procedure body table in |
	procedure := MocoSqlMysqlCreateProcedure new.
	
	in := aMocoOclRdbGeneralizationSetTransformationConstraint keyColumn name.

	procedure name: (MocoNamingUtils toUpperSnakeCase: (aMocoOclRdbGeneralizationSetTransformationConstraint name)).
	procedure inputs add: (MocoSqlMysqlCreateProcedureInput new name: in; type: (self toTypeDeclaration: aMocoOclRdbGeneralizationSetTransformationConstraint keyColumn); yourself).
	
	in := MocoSqlMysqlEscaping escapeName: in.
	
	body := String new writeStream.
	table := MocoNamingUtils toShortName: (aMocoOclRdbGeneralizationSetTransformationConstraint context name).
	
	body nextPutAll: 'SET @discr = (SELECT ';
		nextPutAll: (MocoSqlMysqlEscaping escapeName: (aMocoOclRdbGeneralizationSetTransformationConstraint discriminatorColumn name));
		nextPutAll: ' FROM ';
		nextPutAll: (MocoSqlMysqlEscaping escapeName: (aMocoOclRdbGeneralizationSetTransformationConstraint context name));
		nextPutAll: ' ';
		nextPutAll: (MocoSqlMysqlEscaping escapeName: table);
		nextPutAll: ' WHERE ';
		nextPutAll: (MocoSqlMysqlEscaping escapeName: table);
		nextPutAll: '.';
		nextPutAll: in;
		nextPutAll: ' = ';
		nextPutAll: (MocoSqlMysqlEscaping escapeName: (procedure inputs first name));
		nextPutAll: ');';
		cr;
		nextPutAll: 'IF NOT ('.

	(aMocoOclRdbGeneralizationSetTransformationConstraint values) with: (aMocoOclRdbGeneralizationSetTransformationConstraint configurations) do: [ :v :c |
		(aMocoOclRdbGeneralizationSetTransformationConstraint values first = v)
			ifTrue: [ body nextPutAll: '(' ];
			ifFalse: [ body cr; nextPutAll: '  ) OR (' ].

		body cr;
			nextPutAll: '    @discr = ';
			nextPutAll: (MocoSqlMysqlEscaping escapeLiteral: v).

		(aMocoOclRdbGeneralizationSetTransformationConstraint tables) with: c do: [ :t :e |
			| tableName |
			tableName := (MocoSqlMysqlEscaping escapeName: (MocoNamingUtils toShortName: (t first name))).

			body cr;
				nextPutAll: '    AND'.

			e ifFalse: [ body nextPutAll: ' NOT' ].
			
			body nextPutAll: ' EXISTS (SELECT 1 FROM ';
				nextPutAll: (MocoSqlMysqlEscaping escapeName: (t first name));
				nextPutAll: ' ';
				nextPutAll: tableName;
				nextPutAll: ' WHERE ';
				nextPutAll: tableName;
				nextPutAll: '.';
				nextPutAll: (MocoSqlMysqlEscaping escapeName: (t last name));
				nextPutAll: ' = ';
				nextPutAll: in;
				nextPutAll: ')'
		]
	].

	body cr;
		nextPutAll: ')) THEN';
		cr;
		nextPutAll: '  SIGNAL SQLSTATE ''45000'' SET MESSAGE_TEXT = ';
		nextPutAll: (MocoSqlMysqlEscaping escapeLiteral: ('OCL constraint ' , (aMocoOclRdbGeneralizationSetTransformationConstraint name) , ' violated!'));
		nextPutAll: ';';
		cr;
		nextPutAll: 'END IF;'.

	procedure body: (body contents);
		comment: 'call after INSERT and UPDATE on ' , (MocoSqlMysqlEscaping escapeName: aMocoOclRdbGeneralizationSetTransformationConstraint context name).

	engine addOutputElement: procedure withSource: aMocoOclRdbGeneralizationSetTransformationConstraint
]

{ #category : 'accessing' }
MocoRdbMysqlOclGeneralizationSetTransformationRule >> priority [
	^ 80
]

{ #category : 'private - processing' }
MocoRdbMysqlOclGeneralizationSetTransformationRule >> toTypeDeclaration: aMocoRdbColumn [
	| resolver |
	resolver := MocoSqlMysqlDataTypeResolver instance.

	aMocoRdbColumn type accept: resolver.
	
	^ resolver typeDeclaration
]
