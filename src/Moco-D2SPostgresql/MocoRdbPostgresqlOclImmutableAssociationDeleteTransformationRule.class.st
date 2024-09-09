"
Transforms the OCL postcondition preventing removal from immutable attribute set into a CREATE TRIGGER statement in a PostgreSQL database.
"
Class {
	#name : #MocoRdbPostgresqlOclImmutableAssociationDeleteTransformationRule,
	#superclass : #MocoTransformationRule,
	#category : #'Moco-D2SPostgresql-Rule'
}

{ #category : #transforming }
MocoRdbPostgresqlOclImmutableAssociationDeleteTransformationRule >> execute [
	| ocls |
	ocls := engine input
		selectElementsOfKind: MocoOclRdbImmutableAssociationDeleteCondition
		notGuarded: #MocoRdbPostgresqlOclImmutableAssociationDeleteTransformationRule.
	
	ocls do: [ :each |
		| trigger |
		trigger := self generateTrigger: each.
		
		engine addOutputElement: trigger withSource: each.
		engine input guard: each with: #MocoRdbPostgresqlOclImmutableAssociationDeleteTransformationRule
	]
]

{ #category : #'private - processing' }
MocoRdbPostgresqlOclImmutableAssociationDeleteTransformationRule >> generateTrigger: aMocoOclRdbImmutableAssociationDeleteCondition [
	| trigger body varName |
	trigger := MocoSqlPostgresqlCreateTrigger new.
	
	trigger name: (MocoNamingUtils toUpperSnakeCase: (aMocoOclRdbImmutableAssociationDeleteCondition name));
		table: (aMocoOclRdbImmutableAssociationDeleteCondition context name);
		time: #BEFORE;
		event: #DELETE;
		granularity: #'EACH ROW'.
	
	trigger name: (MocoUniqueNameGenerator at: [ :n | (engine output selectElementsOfKind: MocoSqlPostgresqlCreateTrigger) anySatisfy: [ :each | (each name) = n ] ] seed: (trigger name)).
	
	body := String new writeStream.
	
	varName := MocoSqlPostgresqlEscaping escapeName: (MocoNamingUtils toShortName: (aMocoOclRdbImmutableAssociationDeleteCondition targetTable name)).
	
	body
		nextPutAll: 'IF OLD.';
		nextPutAll: (MocoSqlPostgresqlEscaping escapeName: (aMocoOclRdbImmutableAssociationDeleteCondition column name));
		nextPutAll: ' IS NOT NULL AND EXISTS (';
		cr;
		nextPutAll: '  SELECT 1 FROM ';
		nextPutAll: (MocoSqlPostgresqlEscaping escapeName: (aMocoOclRdbImmutableAssociationDeleteCondition targetTable name));
		nextPutAll: ' ';
		nextPutAll: varName;
		nextPutAll: ' WHERE ';
		nextPutAll: varName;
		nextPutAll: '.';
		nextPutAll: (MocoSqlPostgresqlEscaping escapeName: (aMocoOclRdbImmutableAssociationDeleteCondition targetColumn name));
		nextPutAll: ' = OLD.';
		nextPutAll: (MocoSqlPostgresqlEscaping escapeName: (aMocoOclRdbImmutableAssociationDeleteCondition column name));
		cr;
		nextPutAll: ') THEN';
		cr;
		nextPutAll: '  RAISE EXCEPTION ';
		nextPutAll: (MocoSqlPostgresqlEscaping escapeLiteral: ('OCL constraint ' , (aMocoOclRdbImmutableAssociationDeleteCondition name) , ' violated!'));
		nextPutAll: ';';
		cr;
		nextPutAll: 'END IF;';
		cr;
		nextPutAll: 'RETURN OLD;'.
	
	trigger body: (body contents).
	
	^ trigger
]
