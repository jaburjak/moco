"
Transforms the OCL postcondition preventing removal from immutable attribute set into a CREATE TRIGGER statement in an Oracle relational database.
"
Class {
	#name : #MocoRdbOclImmutableAssociationDeleteTransformationRule,
	#superclass : #MocoTransformationRule,
	#category : #'Moco-D2S-Rule'
}

{ #category : #transforming }
MocoRdbOclImmutableAssociationDeleteTransformationRule >> execute [
	| ocls |
	ocls := engine inModel elements select: [ :each | (each isWrappingType: MocoOclRdbImmutableAssociationDeleteCondition) and: [ each meta isNotProcessedBy: #MocoRdbOclImmutableAssociationDeleteTransformationRule ] ].
	
	ocls do: [ :each |
		| trigger |
		trigger := self generateTrigger: (each innerElement).
		trigger := MocoWrappedElement from: trigger.
		
		each meta outElements add: trigger.
		engine outModel elements add: trigger.
		
		each meta markProcessedBy: #MocoRdbOclImmutableAssociationDeleteTransformationRule
	].

	ocls ifNotEmpty: [ engine outModel meta didChange: true ]
]

{ #category : #'private - processing' }
MocoRdbOclImmutableAssociationDeleteTransformationRule >> generateTrigger: aMocoOclRdbImmutableAssociationDeleteCondition [
	| trigger body varName |
	trigger := MocoSqlOracleCreateTrigger new.
	
	trigger name: (aMocoOclRdbImmutableAssociationDeleteCondition name);
		table: (aMocoOclRdbImmutableAssociationDeleteCondition context name);
		time: #BEFORE;
		event: #DELETE;
		granularity: #'EACH ROW'.
	
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
