"
Transforms the OCL postcondition preventing removal from immutable attribute set into a CREATE TRIGGER statement in an Oracle relational database.
"
Class {
	#name : 'MocoRdbOracleOclImmutableAssociationDeleteTransformationRule',
	#superclass : 'MocoTransformationRule',
	#category : 'Moco-D2SOracle-Rule',
	#package : 'Moco-D2SOracle',
	#tag : 'Rule'
}

{ #category : 'transforming' }
MocoRdbOracleOclImmutableAssociationDeleteTransformationRule >> execute [
	| ocls |
	ocls := engine input
		selectElementsOfKind: MocoOclRdbImmutableAssociationDeleteCondition
		notGuarded: #MocoRdbOracleOclImmutableAssociationDeleteTransformationRule.
	
	ocls do: [ :each |
		| trigger |
		trigger := self generateTrigger: each.
		
		engine addOutputElement: trigger withSource: each.
		engine input guard: each with: #MocoRdbOracleOclImmutableAssociationDeleteTransformationRule
	]
]

{ #category : 'private - processing' }
MocoRdbOracleOclImmutableAssociationDeleteTransformationRule >> generateTrigger: aMocoOclRdbImmutableAssociationDeleteCondition [
	| trigger body varName |
	trigger := MocoSqlOracleCreateTrigger new.
	
	trigger name: (MocoNamingUtils toUpperSnakeCase: (aMocoOclRdbImmutableAssociationDeleteCondition name));
		table: (aMocoOclRdbImmutableAssociationDeleteCondition context name);
		time: #BEFORE;
		event: #DELETE;
		granularity: #'EACH ROW'.
	
	trigger name: (MocoUniqueNameGenerator at: [ :n | (engine output selectElementsOfKind: MocoSqlOracleCreateTrigger) anySatisfy: [ :each | (each name) = n ] ] seed: (trigger name)).
	
	body := String new writeStream.
	
	varName := MocoSqlOracleEscaping escapeName: (MocoNamingUtils toShortName: (aMocoOclRdbImmutableAssociationDeleteCondition targetTable name)).
	
	body
		nextPutAll: 'DECLARE';
		cr;
		nextPutAll: '  "l_count" NUMBER;';
		cr;
		nextPutAll: 'BEGIN';
		cr;
		nextPutAll: '  SELECT COUNT(1) INTO "l_count" FROM DUAL WHERE EXISTS (';
		cr;
		nextPutAll: '    SELECT 1 FROM ';
		nextPutAll: (MocoSqlOracleEscaping escapeName: (aMocoOclRdbImmutableAssociationDeleteCondition targetTable name));
		nextPutAll: ' ';
		nextPutAll: varName;
		nextPutAll: ' WHERE ';
		nextPutAll: varName;
		nextPutAll: '.';
		nextPutAll: (MocoSqlOracleEscaping escapeName: (aMocoOclRdbImmutableAssociationDeleteCondition targetColumn name));
		nextPutAll: ' = :old.';
		nextPutAll: (MocoSqlOracleEscaping escapeName: (aMocoOclRdbImmutableAssociationDeleteCondition column name));
		nextPutAll: ');';
		cr;
		nextPutAll: '  IF :old.';
		nextPutAll: (MocoSqlOracleEscaping escapeName: (aMocoOclRdbImmutableAssociationDeleteCondition column name));
		nextPutAll: ' IS NOT NULL AND "l_count" > 0 THEN';
		cr;
		nextPutAll: '    raise_application_error(-20101, ';
		nextPutAll: (MocoSqlOracleEscaping escapeLiteral: ('OCL constraint ' , (aMocoOclRdbImmutableAssociationDeleteCondition name) , ' violated!'));
		nextPutAll: ');';
		cr;
		nextPutAll: '  END IF;';
		cr;
		nextPutAll: 'END;'.
	
	trigger body: (body contents).
	
	^ trigger
]
