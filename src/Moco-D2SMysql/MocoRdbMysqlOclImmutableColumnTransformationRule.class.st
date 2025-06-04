"
Transforms an OCL immutable column value constraint to a CREATE TRIGGER statement for a MySQL database.
"
Class {
	#name : #MocoRdbMysqlOclImmutableColumnTransformationRule,
	#superclass : #MocoTransformationRule,
	#category : #'Moco-D2SMysql-Rule'
}

{ #category : #transforming }
MocoRdbMysqlOclImmutableColumnTransformationRule >> execute [
	| ocls |
	ocls := engine input
		selectElementsOfKind: MocoOclRdbImmutableColumnCondition
		notGuarded: #MocoRdbMysqlOclImmutableColumnTransformationRule.
	
	ocls do: [ :each |
		| trigger |
		trigger := self generateTrigger: each.
		
		engine addOutputElement: trigger withSource: each.
		engine input guard: each with: #MocoRdbMysqlOclImmutableColumnTransformationRule
	]
]

{ #category : #'private - processing' }
MocoRdbMysqlOclImmutableColumnTransformationRule >> generateTrigger: aMocoOclRdbImmutableColumnCondition [
	| trigger body |
	trigger := MocoSqlMysqlCreateTrigger new.
	
	trigger name: (MocoNamingUtils toUpperSnakeCase: (aMocoOclRdbImmutableColumnCondition name));
		table: (aMocoOclRdbImmutableColumnCondition context name);
		time: #BEFORE;
		event: #UPDATE.
	
	trigger name: (MocoUniqueNameGenerator at: [ :n | (engine output selectElementsOfKind: MocoSqlMysqlCreateTrigger) anySatisfy: [ :each | (each name) = n ] ] seed: (trigger name)).
	
	body := String new writeStream.
	
	body
		nextPutAll: 'IF OLD.';
		nextPutAll: (MocoSqlMysqlEscaping escapeName: (aMocoOclRdbImmutableColumnCondition column name));
		nextPutAll: ' <> NEW.';
		nextPutAll: (MocoSqlMysqlEscaping escapeName: (aMocoOclRdbImmutableColumnCondition column name));
		nextPutAll: ' THEN';
		cr;
		nextPutAll: '  SIGNAL SQLSTATE ''45000'' SET MESSAGE_TEXT = ';
		nextPutAll: (MocoSqlMysqlEscaping escapeLiteral: ('OCL constraint ' , (aMocoOclRdbImmutableColumnCondition name) , ' violated!'));
		nextPutAll: ';';
		cr;
		nextPutAll: 'END IF;'.
	
	trigger body: (body contents).
	
	^ trigger
]
