"
Transforms an OCL immutable column value constraint to a CREATE TRIGGER statement for a PostgreSQL database.
"
Class {
	#name : #MocoRdbPostgresqlOclImmutableColumnTransformationRule,
	#superclass : #MocoTransformationRule,
	#category : #'Moco-D2SPostgresql-Rule'
}

{ #category : #transforming }
MocoRdbPostgresqlOclImmutableColumnTransformationRule >> execute [
	| ocls |
	ocls := engine input
		selectElementsOfKind: MocoOclRdbImmutableColumnCondition
		notGuarded: #MocoRdbPostgresqlOclImmutableColumnTransformationRule.
	
	ocls do: [ :each |
		| trigger |
		trigger := self generateTrigger: each.
		
		engine addOutputElement: trigger withSource: each.
		engine input guard: each with: #MocoRdbPostgresqlOclImmutableColumnTransformationRule
	]
]

{ #category : #'private - processing' }
MocoRdbPostgresqlOclImmutableColumnTransformationRule >> generateTrigger: aMocoOclRdbImmutableColumnCondition [
	| trigger body |
	trigger := MocoSqlPostgresqlCreateTrigger new.
	
	trigger name: (MocoNamingUtils toUpperSnakeCase: (aMocoOclRdbImmutableColumnCondition name));
		table: (aMocoOclRdbImmutableColumnCondition context name);
		time: #BEFORE;
		event: #UPDATE;
		granularity: #'EACH ROW'.
	
	trigger name: (MocoUniqueNameGenerator at: [ :n | (engine output selectElementsOfKind: MocoSqlPostgresqlCreateTrigger) anySatisfy: [ :each | (each name) = n ] ] seed: (trigger name)).
	
	body := String new writeStream.
	
	body
		nextPutAll: 'IF OLD.';
		nextPutAll: (MocoSqlPostgresqlEscaping escapeName: (aMocoOclRdbImmutableColumnCondition column name));
		nextPutAll: ' <> NEW.';
		nextPutAll: (MocoSqlPostgresqlEscaping escapeName: (aMocoOclRdbImmutableColumnCondition column name));
		nextPutAll: ' THEN';
		cr;
		nextPutAll: '  RAISE EXCEPTION ';
		nextPutAll: (MocoSqlPostgresqlEscaping escapeLiteral: ('OCL constraint ' , (aMocoOclRdbImmutableColumnCondition name) , ' violated!'));
		nextPutAll: ';';
		cr;
		nextPutAll: 'END IF;';
		cr;
		nextPutAll: 'RETURN NEW;'.
	
	trigger body: (body contents).
	
	^ trigger
]
