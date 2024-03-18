"
Transforms an OCL immutable column value constraint to a CREATE TRIGGER statement for an Oracle relational database.
"
Class {
	#name : #MocoRdbOclImmutableColumnTransformationRule,
	#superclass : #MocoTransformationRule,
	#category : #'Moco-D2S-Rule'
}

{ #category : #transforming }
MocoRdbOclImmutableColumnTransformationRule >> execute [
	| ocls |
	ocls := engine inModel elements select: [ :each | (each isWrappingType: MocoOclRdbImmutableColumnCondition) and: [ each meta isNotProcessedBy: #MocoRdbOclImmutableColumnTransformationRule ] ].
	
	ocls do: [ :each |
		| trigger |
		trigger := self generateTrigger: (each innerElement).
		trigger := MocoWrappedElement from: trigger.
		
		each meta outElements add: trigger.
		engine outModel elements add: trigger.
		
		each meta markProcessedBy: #MocoRdbOclImmutableColumnTransformationRule
	].

	ocls ifNotEmpty: [ engine outModel meta didChange: true ]
]

{ #category : #'private - processing' }
MocoRdbOclImmutableColumnTransformationRule >> generateTrigger: aMocoOclRdbImmutableColumnCondition [
	| trigger body |
	trigger := MocoSqlOracleCreateTrigger new.
	
	trigger name: (aMocoOclRdbImmutableColumnCondition name);
		table: (aMocoOclRdbImmutableColumnCondition context name);
		time: #BEFORE;
		event: #UPDATE;
		granularity: #'EACH ROW'.
	
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
