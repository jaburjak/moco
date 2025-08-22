"
Transforms the generalization set OCL constraint into a series of TRIGGER and PROCEDURE definitions.
"
Class {
	#name : 'MocoRdbMssqlOclGeneralizationSetTransformationRule',
	#superclass : 'MocoTransformationRule',
	#category : 'Moco-D2SMssql-Rule',
	#package : 'Moco-D2SMssql',
	#tag : 'Rule'
}

{ #category : 'transforming' }
MocoRdbMssqlOclGeneralizationSetTransformationRule >> execute [
	| ocls |
	ocls := engine input
		selectElementsOfKind: MocoOclRdbGeneralizationSetConstraint
		notGuarded: #MocoRdbMssqlOclGeneralizationSetTransformationRule.
	
	ocls do: [ :each |
		| triggers |
		triggers := OrderedCollection new.
		
		triggers
			add: (self generateSuperclassTrigger: each);
			addAll: (self generateSubclassInsertTriggers: each);
			addAll: (self generateSubclassUpdateProcedures: each);
			addAll: (self generateSubclassDeleteTriggers: each).
		
		triggers do: [ :e | engine addOutputElement: e withSource: each ].
		
		engine input guard: each with: #MocoRdbMssqlOclGeneralizationSetTransformationRule
	]
]

{ #category : 'private - transforming' }
MocoRdbMssqlOclGeneralizationSetTransformationRule >> generateSubclassDeleteTrigger: aMocoOclRdbGeneralizationSetTransformationConstraint forTable: aMocoRdbTable withColumn: aMocoRdbColumn [
	| trigger body varName |
	trigger := MocoSqlMssqlCreateTrigger new.
	
	trigger name: ((MocoNamingUtils toUpperSnakeCase: (aMocoOclRdbGeneralizationSetTransformationConstraint name)) , '_' , (aMocoRdbTable name) , '_DEL');
		table: (aMocoRdbTable name);
		event: #DELETE.
		
	body := String new writeStream.
	
	varName := MocoNamingUtils toShortName: (aMocoOclRdbGeneralizationSetTransformationConstraint context name).
	varName := MocoUniqueNameGenerator at: [ :n | n = 'd' ] seed: varName.
	varName := MocoSqlMssqlEscaping escapeName: varName.
	
	body
		nextPutAll: 'IF EXISTS (';
		cr;
		nextPutAll: '  SELECT 1 FROM [deleted] [d] JOIN ';
		nextPutAll: (MocoSqlMssqlEscaping escapeName: (aMocoOclRdbGeneralizationSetTransformationConstraint context name));
		nextPutAll: ' ';
		nextPutAll: varName;
		nextPutAll: ' ON ';
		nextPutAll: varName;
		nextPutAll: '.';
		nextPutAll: (MocoSqlMssqlEscaping escapeName: (aMocoOclRdbGeneralizationSetTransformationConstraint keyColumn name));
		nextPutAll: ' = [d].';
		nextPutAll: (MocoSqlMssqlEscaping escapeName: (aMocoRdbColumn name));
		cr;
		nextPutAll: ') BEGIN';
		cr;
		nextPutAll: '    THROW 5000, ';
		nextPutAll: (MocoSqlMssqlEscaping escapeLiteral: ('OCL constraint ' , (aMocoOclRdbGeneralizationSetTransformationConstraint name) , ' violated!'));
		nextPutAll: ', 4;';
		cr;
		nextPutAll: 'END;'.
	
	trigger body: (body contents).
	
	^ trigger
]

{ #category : 'private - processing' }
MocoRdbMssqlOclGeneralizationSetTransformationRule >> generateSubclassDeleteTriggers: aMocoOclRdbGeneralizationSetTransformationConstraint [
	^ aMocoOclRdbGeneralizationSetTransformationConstraint tables collect: [ :each |
		self generateSubclassDeleteTrigger: aMocoOclRdbGeneralizationSetTransformationConstraint forTable: (each first) withColumn: (each last)
	]
]

{ #category : 'private - transforming' }
MocoRdbMssqlOclGeneralizationSetTransformationRule >> generateSubclassInsertTrigger: aMocoOclRdbGeneralizationSetTransformationConstraint forTable: aMocoRdbTable withColumn: aMocoRdbColumn [
	| trigger body varName |
	trigger := MocoSqlMssqlCreateTrigger new.
	
	trigger name: ((MocoNamingUtils toUpperSnakeCase: (aMocoOclRdbGeneralizationSetTransformationConstraint name)) , '_' , (aMocoRdbTable name) , '_INS');
		table: (aMocoRdbTable name);
		event: #INSERT.
		
	body := String new writeStream.
	
	varName := MocoNamingUtils toShortName: (aMocoOclRdbGeneralizationSetTransformationConstraint context name).
	varName := MocoUniqueNameGenerator at: [ :n | n = 'i' ] seed: varName.
	varName := MocoSqlMssqlEscaping escapeName: varName.
	
	body
		nextPutAll: 'IF EXISTS (';
		cr;
		nextPutAll: '    SELECT 1 FROM [inserted] [i] JOIN ';
		nextPutAll: (MocoSqlMssqlEscaping escapeName: (aMocoOclRdbGeneralizationSetTransformationConstraint context name));
		nextPutAll: ' ';
		nextPutAll: varName;
		nextPutAll: ' ON ';
		nextPutAll: varName;
		nextPutAll: '.';
		nextPutAll: (MocoSqlMssqlEscaping escapeName: (aMocoOclRdbGeneralizationSetTransformationConstraint keyColumn name));
		nextPutAll: ' = [i].';
		nextPutAll: (MocoSqlMssqlEscaping escapeName: (aMocoRdbColumn name));
		cr;
		nextPutAll: ') BEGIN';
		cr;
		nextPutAll: '  THROW 5000, ';
		nextPutAll: (MocoSqlMssqlEscaping escapeLiteral: ('OCL constraint ' , (aMocoOclRdbGeneralizationSetTransformationConstraint name) , ' violated!'));
		nextPutAll: ', 2;';
		cr;
		nextPutAll: 'END;'.
	
	trigger body: (body contents).
	
	^ trigger
]

{ #category : 'private - processing' }
MocoRdbMssqlOclGeneralizationSetTransformationRule >> generateSubclassInsertTriggers: aMocoOclRdbGeneralizationSetTransformationConstraint [
	^ aMocoOclRdbGeneralizationSetTransformationConstraint tables collect: [ :each |
		self generateSubclassInsertTrigger: aMocoOclRdbGeneralizationSetTransformationConstraint forTable: (each first) withColumn: (each last)
	]
]

{ #category : 'private - transforming' }
MocoRdbMssqlOclGeneralizationSetTransformationRule >> generateSubclassUpdateProcedure: aMocoOclRdbGeneralizationSetTransformationConstraint forTable: aMocoRdbTable withColumn: aMocoRdbColumn [
	| procedure body varName |
	procedure := MocoSqlMssqlCreateProcedure new.
	
	procedure name: ((MocoNamingUtils toUpperSnakeCase: (aMocoOclRdbGeneralizationSetTransformationConstraint name)) , '_' , (aMocoRdbTable name) , '_UPD').
	procedure inputs add: (MocoSqlMssqlCreateProcedureInput new name: ('OLD_' , (aMocoRdbColumn name)); type: (self toTypeDeclaration: aMocoRdbColumn); yourself).
	procedure inputs add: (MocoSqlMssqlCreateProcedureInput new name: ('NEW_' , (aMocoRdbColumn name)); type: (self toTypeDeclaration: aMocoRdbColumn); yourself).
		
	body := String new writeStream.
	
	varName := MocoSqlMssqlEscaping escapeName: (MocoNamingUtils toShortName: (aMocoOclRdbGeneralizationSetTransformationConstraint context name)).
	
	body
		nextPutAll: 'IF @';
		nextPutAll: (procedure inputs first name);
		nextPutAll: ' <> @';
		nextPutAll: (procedure inputs last name);
		nextPutAll: ' BEGIN';
		cr;
		nextPutAll: '  IF EXISTS (';
		cr;
		nextPutAll: '    SELECT 1 FROM ';
		nextPutAll: (MocoSqlMssqlEscaping escapeName: (aMocoOclRdbGeneralizationSetTransformationConstraint context name));
		nextPutAll: ' ';
		nextPutAll: varName;
		nextPutAll: ' WHERE ';
		nextPutAll:
			(' OR ' join: (
				procedure inputs collect: [ :i | varName , '.' , (MocoSqlMssqlEscaping escapeName: (aMocoOclRdbGeneralizationSetTransformationConstraint keyColumn name)) , ' = @' , (i name) ]));
		cr;
		nextPutAll: '  ) BEGIN';
		cr;
		nextPutAll: '    THROW 5000, ';
		nextPutAll: (MocoSqlMssqlEscaping escapeLiteral: ('OCL constraint ' , (aMocoOclRdbGeneralizationSetTransformationConstraint name) , ' violated!'));
		nextPutAll: ', 3;';
		cr;
		nextPutAll: '  END;';
		cr;
		nextPutAll: 'END;'.
	
	procedure body: (body contents).
	
	procedure comment: ('call after UPDATE on ' , (MocoSqlMssqlEscaping escapeName: (aMocoRdbTable name))).
	
	^ procedure
]

{ #category : 'private - processing' }
MocoRdbMssqlOclGeneralizationSetTransformationRule >> generateSubclassUpdateProcedures: aMocoOclRdbGeneralizationSetTransformationConstraint [
	^ aMocoOclRdbGeneralizationSetTransformationConstraint tables collect: [ :each |
		self generateSubclassUpdateProcedure: aMocoOclRdbGeneralizationSetTransformationConstraint forTable: (each first) withColumn: (each last)
	]
]

{ #category : 'private - processing' }
MocoRdbMssqlOclGeneralizationSetTransformationRule >> generateSuperclassTrigger: aMocoOclRdbGeneralizationSetTransformationConstraint [
	| trigger body |
	trigger := MocoSqlMssqlCreateTrigger new.
	
	trigger name: (MocoNamingUtils toUpperSnakeCase: (aMocoOclRdbGeneralizationSetTransformationConstraint name));
		table: (aMocoOclRdbGeneralizationSetTransformationConstraint context name);
		event: #'INSERT, UPDATE'.
		
	body := String new writeStream.
	
	body
		nextPutAll: 'IF EXISTS (SELECT 1 FROM [inserted] [i] WHERE NOT ('.
	
	(aMocoOclRdbGeneralizationSetTransformationConstraint values) with: (aMocoOclRdbGeneralizationSetTransformationConstraint configurations) do: [ :v :c |
		(v = aMocoOclRdbGeneralizationSetTransformationConstraint values first) ifFalse: [ body cr; nextPutAll: '  ) OR ' ].
		
		body
			nextPutAll: '(';
			cr;
			nextPutAll: '    [i].';
			nextPutAll: (MocoSqlMssqlEscaping escapeName: (aMocoOclRdbGeneralizationSetTransformationConstraint discriminatorColumn name));
			nextPutAll: ' = ';
			nextPutAll: (MocoSqlMssqlEscaping escapeLiteral: v).
		
		(aMocoOclRdbGeneralizationSetTransformationConstraint tables) with: c do: [ :t :e |
			| varName |
			varName := MocoNamingUtils toShortName: (t first name).
			varName := MocoUniqueNameGenerator at: [ :n | n = 'i' ] seed: varName.
			varName := MocoSqlMssqlEscaping escapeName: varName.
			
			body cr; nextPutAll: '    AND '.
			e ifFalse: [ body nextPutAll: 'NOT ' ].
			
			body
				nextPutAll: 'EXISTS (SELECT 1 FROM ';
				nextPutAll: (MocoSqlMssqlEscaping escapeName: (t first name));
				nextPutAll: ' ';
				nextPutAll: varName;
				nextPutAll: ' WHERE ';
				nextPutAll: varName;
				nextPutAll: '.';
				nextPutAll: (MocoSqlMssqlEscaping escapeName: (t last name));
				nextPutAll: ' = [i].';
				nextPutAll: (MocoSqlMssqlEscaping escapeName: (aMocoOclRdbGeneralizationSetTransformationConstraint keyColumn name));
				nextPutAll: ')'
		].
	].

	body
		cr;
		nextPutAll: '))) BEGIN';
		cr;
		nextPutAll: '  THROW 5000, ';
		nextPutAll: (MocoSqlMssqlEscaping escapeLiteral: ('OCL constraint ' , (aMocoOclRdbGeneralizationSetTransformationConstraint name) , ' violated!'));
		nextPutAll: ', 1;';
		cr;
		nextPutAll: 'END;'.
	
	trigger body: (body contents).
	
	^ trigger
]

{ #category : 'private - processing' }
MocoRdbMssqlOclGeneralizationSetTransformationRule >> toTypeDeclaration: aMocoRdbColumn [
	| resolver |
	resolver := MocoSqlMssqlDataTypeResolver instance.

	aMocoRdbColumn type accept: resolver.
	
	^ resolver typeDeclaration
]
