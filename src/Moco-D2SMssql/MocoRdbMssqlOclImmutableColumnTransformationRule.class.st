"
Transforms an OCL immutable column value constraint to a CREATE TRIGGER statement.
"
Class {
	#name : 'MocoRdbMssqlOclImmutableColumnTransformationRule',
	#superclass : 'MocoTransformationRule',
	#category : 'Moco-D2SMssql-Rule',
	#package : 'Moco-D2SMssql',
	#tag : 'Rule'
}

{ #category : 'transforming' }
MocoRdbMssqlOclImmutableColumnTransformationRule >> execute [
	| ocls |
	ocls := engine input
		selectElementsOfKind: MocoOclRdbImmutableColumnCondition
		notGuarded: #MocoRdbMssqlOclImmutableColumnTransformationRule.
	
	ocls do: [ :each |
		| trigger |
		trigger := self generateTrigger: each.
		
		engine addOutputElement: trigger withSource: each.
		engine input guard: each with: #MocoRdbMssqlOclImmutableColumnTransformationRule
	]
]

{ #category : 'private - processing' }
MocoRdbMssqlOclImmutableColumnTransformationRule >> findPrimaryKeyOf: aMocoRdbTable [
	| key |
	key := aMocoRdbTable constraints detect: [ :c | c isKindOf: MocoRdbPrimaryKey ] ifNone: [ nil ].
	key ifNil: [ ^ nil ].
	^ key columns
]

{ #category : 'private - processing' }
MocoRdbMssqlOclImmutableColumnTransformationRule >> generateTrigger: aMocoOclRdbImmutableColumnCondition [
	| trigger body name primaryKey |
	trigger := MocoSqlMssqlCreateTrigger new.
	
	trigger name: (MocoNamingUtils toUpperSnakeCase: (aMocoOclRdbImmutableColumnCondition name));
		table: (aMocoOclRdbImmutableColumnCondition context name);
		event: #UPDATE.
	
	trigger name: (MocoUniqueNameGenerator at: [ :n | (engine output selectElementsOfKind: MocoSqlMssqlCreateTrigger) anySatisfy: [ :each | (each name) = n ] ] seed: (trigger name)).
	
	name := MocoSqlMssqlEscaping escapeName: (aMocoOclRdbImmutableColumnCondition column name).
	
	primaryKey := self findPrimaryKeyOf: (aMocoOclRdbImmutableColumnCondition context).
	
	primaryKey ifNil: [ self error: 'MocoRdbMssqlOclImmutableColumnTransformationRule cannot operate on a table without a primary key.' ].
	
	body := String new writeStream.
	
	body
		nextPutAll: 'IF UPDATE(';
		nextPutAll: name;
		nextPutAll: ') AND EXISTS (';
		cr;
		nextPutAll: '  SELECT 1 FROM [inserted] [i] JOIN [deleted] [d] ON '.
	
	(primaryKey size > 1) ifTrue: [ body nextPutAll: '(' ].
	body nextPutAll: (' AND ' join: (primaryKey collect: [ :k |
		| n |
		n := MocoSqlMssqlEscaping escapeName: (k name).
		'[i].' , n , ' = [d].' , n ])).
	(primaryKey size > 1) ifTrue: [ body nextPutAll: ')' ].
	
	body
		nextPutAll: ' WHERE [i].';
		nextPutAll: name;
		nextPutAll: ' <> [d].';
		nextPutAll: name;
		cr;
		nextPutAll: ') BEGIN';
		cr;
		nextPutAll: '  THROW 5000, ';
		nextPutAll: (MocoSqlMssqlEscaping escapeLiteral: ('OCL constraint ' , (aMocoOclRdbImmutableColumnCondition name) , ' violated!'));
		nextPutAll: ', 1;';
		cr;
		nextPutAll: 'END;'.
	
	trigger body: (body contents).
	
	^ trigger
]
