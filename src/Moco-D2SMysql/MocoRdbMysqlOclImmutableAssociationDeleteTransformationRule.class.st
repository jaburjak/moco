"
Transforms the OCL postcondition preventing removal from immutable attribute set into a CREATE TRIGGER statement in a MySQL database.
"
Class {
	#name : #MocoRdbMysqlOclImmutableAssociationDeleteTransformationRule,
	#superclass : #MocoTransformationRule,
	#category : #'Moco-D2SMysql-Rule'
}

{ #category : #transforming }
MocoRdbMysqlOclImmutableAssociationDeleteTransformationRule >> execute [
	| ocls |
	ocls := engine input
		selectElementsOfKind: MocoOclRdbImmutableAssociationDeleteCondition
		notGuarded: #MocoRdbMysqlOclImmutableAssociationDeleteTransformationRule.
	
	ocls do: [ :each |
		| trigger |
		trigger := self generateTrigger: each.
		
		engine addOutputElement: trigger withSource: each.
		engine input guard: each with: #MocoRdbMysqlOclImmutableAssociationDeleteTransformationRule
	]
]

{ #category : #'private - processing' }
MocoRdbMysqlOclImmutableAssociationDeleteTransformationRule >> generateTrigger: aMocoOclRdbImmutableAssociationDeleteCondition [
	| trigger body varName |
	trigger := MocoSqlMysqlCreateTrigger new.
	
	trigger name: (MocoNamingUtils toUpperSnakeCase: (aMocoOclRdbImmutableAssociationDeleteCondition name));
		table: (aMocoOclRdbImmutableAssociationDeleteCondition context name);
		time: #BEFORE;
		event: #DELETE.
	
	trigger name: (MocoUniqueNameGenerator at: [ :n | (engine output selectElementsOfKind: MocoSqlMysqlCreateTrigger) anySatisfy: [ :each | (each name) = n ] ] seed: (trigger name)).
	
	body := String new writeStream.
	
	varName := MocoSqlMysqlEscaping escapeName: (MocoNamingUtils toShortName: (aMocoOclRdbImmutableAssociationDeleteCondition targetTable name)).
	
	body
		nextPutAll: 'IF OLD.';
		nextPutAll: (MocoSqlMysqlEscaping escapeName: (aMocoOclRdbImmutableAssociationDeleteCondition column name));
		nextPutAll: ' IS NOT NULL AND EXISTS (';
		cr;
		nextPutAll: '  SELECT 1 FROM ';
		nextPutAll: (MocoSqlMysqlEscaping escapeName: (aMocoOclRdbImmutableAssociationDeleteCondition targetTable name));
		nextPutAll: ' ';
		nextPutAll: varName;
		nextPutAll: ' WHERE ';
		nextPutAll: varName;
		nextPutAll: '.';
		nextPutAll: (MocoSqlMysqlEscaping escapeName: (aMocoOclRdbImmutableAssociationDeleteCondition targetColumn name));
		nextPutAll: ' = OLD.';
		nextPutAll: (MocoSqlMysqlEscaping escapeName: (aMocoOclRdbImmutableAssociationDeleteCondition column name));
		cr;
		nextPutAll: ') THEN';
		cr;
		nextPutAll: '  SIGNAL SQLSTATE ''45000'' SET MESSAGE_TEXT = ';
		nextPutAll: (MocoSqlMysqlEscaping escapeLiteral: ('OCL constraint ' , (aMocoOclRdbImmutableAssociationDeleteCondition name) , ' violated!'));
		nextPutAll: ';';
		cr;
		nextPutAll: 'END IF;'.
	
	trigger body: (body contents).
	
	^ trigger
]
