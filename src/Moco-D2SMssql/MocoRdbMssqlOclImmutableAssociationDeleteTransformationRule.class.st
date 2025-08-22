"
Transforms the OCL postcondition preventing removal from immutable attribute set into a CREATE TRIGGER statement.
"
Class {
	#name : 'MocoRdbMssqlOclImmutableAssociationDeleteTransformationRule',
	#superclass : 'MocoTransformationRule',
	#category : 'Moco-D2SMssql-Rule',
	#package : 'Moco-D2SMssql',
	#tag : 'Rule'
}

{ #category : 'transforming' }
MocoRdbMssqlOclImmutableAssociationDeleteTransformationRule >> execute [
	| ocls |
	ocls := engine input
		selectElementsOfKind: MocoOclRdbImmutableAssociationDeleteCondition
		notGuarded: #MocoRdbMssqlOclImmutableAssociationDeleteTransformationRule.
	
	ocls do: [ :each |
		| trigger |
		trigger := self generateTrigger: each.
		
		engine addOutputElement: trigger withSource: each.
		engine input guard: each with: #MocoRdbMssqlOclImmutableAssociationDeleteTransformationRule
	]
]

{ #category : 'private - processing' }
MocoRdbMssqlOclImmutableAssociationDeleteTransformationRule >> generateTrigger: aMocoOclRdbImmutableAssociationDeleteCondition [
	| trigger body varName |
	trigger := MocoSqlMssqlCreateTrigger new.
	
	trigger name: (MocoNamingUtils toUpperSnakeCase: (aMocoOclRdbImmutableAssociationDeleteCondition name));
		table: (aMocoOclRdbImmutableAssociationDeleteCondition context name);
		event: #DELETE.
	
	trigger name: (MocoUniqueNameGenerator at: [ :n | (engine output selectElementsOfKind: MocoSqlMssqlCreateTrigger) anySatisfy: [ :each | (each name) = n ] ] seed: (trigger name)).
	
	body := String new writeStream.
	
	varName := MocoNamingUtils toShortName: (aMocoOclRdbImmutableAssociationDeleteCondition targetTable name).
	varName := MocoUniqueNameGenerator at: [ :n | n = 'd' ] seed: varName.
	varName := MocoSqlMssqlEscaping escapeName: varName.
	
	body
		nextPutAll: 'IF EXISTS (';
		cr;
		nextPutAll: '  SELECT 1 FROM [deleted] [d] JOIN ';
		nextPutAll: (MocoSqlMssqlEscaping escapeName: (aMocoOclRdbImmutableAssociationDeleteCondition targetTable name));
		nextPutAll: ' ';
		nextPutAll: varName;
		nextPutAll: ' ON ';
		nextPutAll: varName;
		nextPutAll: '.';
		nextPutAll: (MocoSqlMssqlEscaping escapeName: (aMocoOclRdbImmutableAssociationDeleteCondition targetColumn name));
		nextPutAll: ' = [d].';
		nextPutAll: (MocoSqlMssqlEscaping escapeName: (aMocoOclRdbImmutableAssociationDeleteCondition column name));
		cr;
		nextPutAll: ') BEGIN';
		cr;
		nextPutAll: '  THROW 5000, ';
		nextPutAll: (MocoSqlMssqlEscaping escapeLiteral: ('OCL constraint ' , (aMocoOclRdbImmutableAssociationDeleteCondition name) , ' violated!'));
		nextPutAll: ', 1;';
		cr;
		nextPutAll: 'END;'.
	
	trigger body: (body contents).
	
	^ trigger
]
