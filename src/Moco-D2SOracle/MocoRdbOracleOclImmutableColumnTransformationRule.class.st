"
Transforms an OCL immutable column value constraint to a CREATE TRIGGER statement for an Oracle relational database.
"
Class {
	#name : 'MocoRdbOracleOclImmutableColumnTransformationRule',
	#superclass : 'MocoTransformationRule',
	#category : 'Moco-D2SOracle-Rule',
	#package : 'Moco-D2SOracle',
	#tag : 'Rule'
}

{ #category : 'transforming' }
MocoRdbOracleOclImmutableColumnTransformationRule >> execute [
	| ocls |
	ocls := engine input
		selectElementsOfKind: MocoOclRdbImmutableColumnCondition
		notGuarded: #MocoRdbOracleOclImmutableColumnTransformationRule.
	
	ocls do: [ :each |
		| trigger |
		trigger := self generateTrigger: each.
		
		engine addOutputElement: trigger withSource: each.
		engine input guard: each with: #MocoRdbOracleOclImmutableColumnTransformationRule
	]
]

{ #category : 'private - processing' }
MocoRdbOracleOclImmutableColumnTransformationRule >> generateTrigger: aMocoOclRdbImmutableColumnCondition [
	| trigger body |
	trigger := MocoSqlOracleCreateTrigger new.
	
	trigger name: (MocoNamingUtils toUpperSnakeCase: (aMocoOclRdbImmutableColumnCondition name));
		table: (aMocoOclRdbImmutableColumnCondition context name);
		time: #BEFORE;
		event: #UPDATE;
		granularity: #'EACH ROW'.
	
	trigger name: (MocoUniqueNameGenerator at: [ :n | (engine output selectElementsOfKind: MocoSqlOracleCreateTrigger) anySatisfy: [ :each | (each name) = n ] ] seed: (trigger name)).
	
	body := String new writeStream.
	
	body
		nextPutAll: 'BEGIN';
		cr;
		nextPutAll: '  IF :old.';
		nextPutAll: (MocoSqlOracleEscaping escapeName: (aMocoOclRdbImmutableColumnCondition column name));
		nextPutAll: ' <> :new.';
		nextPutAll: (MocoSqlOracleEscaping escapeName: (aMocoOclRdbImmutableColumnCondition column name));
		nextPutAll: ' THEN';
		cr;
		nextPutAll: '    raise_application_error(-20101, ';
		nextPutAll: (MocoSqlOracleEscaping escapeLiteral: ('OCL constraint ' , (aMocoOclRdbImmutableColumnCondition name) , ' violated!'));
		nextPutAll: ');';
		cr;
		nextPutAll: '  END IF;';
		cr;
		nextPutAll: 'END;'.
	
	trigger body: (body contents).
	
	^ trigger
]
