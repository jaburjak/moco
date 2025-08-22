"
Transforms special association multiplicity OCL constraint to CREATE TRIGGER statements.
"
Class {
	#name : 'MocoRdbMssqlOclMandatoryMultiplicityTransformationRule',
	#superclass : 'MocoTransformationRule',
	#category : 'Moco-D2SMssql-Rule',
	#package : 'Moco-D2SMssql',
	#tag : 'Rule'
}

{ #category : 'transforming' }
MocoRdbMssqlOclMandatoryMultiplicityTransformationRule >> execute [
	| ocls |
	ocls := engine input
		selectElementsOfKind: MocoOclRdbMandatoryMultiplicityConstraint
		notGuarded: #MocoRdbMssqlOclMandatoryMultiplicityTransformationRule.
	
	ocls do: [ :each |
		| triggers |
		triggers := OrderedCollection new.
		
		triggers
			add: (self generateTargetTrigger: each);
			add: (self generateSourceTrigger: each).
		
		triggers do: [ :e | engine addOutputElement: e withSource: each ].
		engine input guard: each with: #MocoRdbMssqlOclMandatoryMultiplicityTransformationRule
	]
]

{ #category : 'private - processing' }
MocoRdbMssqlOclMandatoryMultiplicityTransformationRule >> generateSourceTrigger: aMocoOclRdbMandatoryMultiplicityConstraint [
	| trigger body varName varName2 |
	trigger := MocoSqlMssqlCreateTrigger new.
	
	trigger name: ((MocoNamingUtils toUpperSnakeCase: (aMocoOclRdbMandatoryMultiplicityConstraint name)) , '_REL');
		table: (aMocoOclRdbMandatoryMultiplicityConstraint sourceTable name);
		event: #'UPDATE, DELETE'.
	
	body := String new writeStream.
	
	varName := MocoNamingUtils toShortName: (aMocoOclRdbMandatoryMultiplicityConstraint context name).
	varName2 := MocoNamingUtils toShortName: (aMocoOclRdbMandatoryMultiplicityConstraint sourceTable name).
	varName2 := MocoUniqueNameGenerator at: [ :each | each = varName ] seed: varName2.
	varName := MocoSqlMssqlEscaping escapeName: varName.
	varName2 := MocoSqlMssqlEscaping escapeName: varName2.
	
	body
		nextPutAll: 'IF EXISTS (';
		cr;
		nextPutAll: '  SELECT 1 FROM ';
		nextPutAll: (MocoSqlMssqlEscaping escapeName: (aMocoOclRdbMandatoryMultiplicityConstraint context name));
		nextPutAll: ' ';
		nextPutAll: varName;
		nextPutAll: ' WHERE NOT EXISTS (';
		cr;
		nextPutAll: '    SELECT 1 FROM ';
		nextPutAll: (MocoSqlMssqlEscaping escapeName: (aMocoOclRdbMandatoryMultiplicityConstraint sourceTable name));
		nextPutAll: ' ';
		nextPutAll: varName2;
		nextPutAll: ' WHERE ';
		nextPutAll: varName2;
		nextPutAll: '.';
		nextPutAll: (MocoSqlMssqlEscaping escapeName: (aMocoOclRdbMandatoryMultiplicityConstraint sourceColumn name));
		nextPutAll: ' = ';
		nextPutAll: varName;
		nextPutAll: '.';
		nextPutAll: (MocoSqlMssqlEscaping escapeName: (aMocoOclRdbMandatoryMultiplicityConstraint targetColumn name));
		cr;
		nextPutAll: ')) BEGIN';
		cr;
		nextPutAll: '  THROW 5000, ';
		nextPutAll: (MocoSqlMssqlEscaping escapeLiteral: ('OCL constraint ' , (aMocoOclRdbMandatoryMultiplicityConstraint name) , ' violated!'));
		nextPutAll: ', 2;';
		cr;
		nextPutAll: 'END;'.
	
	trigger body: (body contents).
	
	^ trigger
]

{ #category : 'private - processing' }
MocoRdbMssqlOclMandatoryMultiplicityTransformationRule >> generateTargetTrigger: aMocoOclRdbMandatoryMultiplicityConstraint [
	| trigger body varName |
	trigger := MocoSqlMssqlCreateTrigger new.
	
	trigger name: (MocoNamingUtils toUpperSnakeCase: (aMocoOclRdbMandatoryMultiplicityConstraint name));
		table: (aMocoOclRdbMandatoryMultiplicityConstraint context name);
		event: #'INSERT, UPDATE'.
	
	varName := MocoNamingUtils toShortName: (aMocoOclRdbMandatoryMultiplicityConstraint sourceTable name).
	varName := MocoUniqueNameGenerator at: [ :n | n = 'i' ] seed: varName.
	varName := MocoSqlMssqlEscaping escapeName: varName.
	
	body := String new writeStream.
	
	body
		nextPutAll: 'IF EXISTS (';
		cr;
		nextPutAll: '  SELECT 1 FROM [inserted] [i] WHERE NOT EXISTS (';
		cr;
		nextPutAll: '    SELECT 1 FROM ';
		nextPutAll: (MocoSqlMssqlEscaping escapeName: (aMocoOclRdbMandatoryMultiplicityConstraint sourceTable name));
		nextPutAll: ' ';
		nextPutAll: varName;
		nextPutAll: ' WHERE ';
		nextPutAll: varName;
		nextPutAll: '.';
		nextPutAll: (MocoSqlMssqlEscaping escapeName: (aMocoOclRdbMandatoryMultiplicityConstraint sourceColumn name));
		nextPutAll: ' = [i].';
		nextPutAll: (MocoSqlMssqlEscaping escapeName: (aMocoOclRdbMandatoryMultiplicityConstraint targetColumn name));
		cr;
		nextPutAll: ')) BEGIN';
		cr;
		nextPutAll: '  THROW 5000, ';
		nextPutAll: (MocoSqlMssqlEscaping escapeLiteral: ('OCL constraint ' , (aMocoOclRdbMandatoryMultiplicityConstraint name) , ' violated!'));
		nextPutAll: ', 1;';
		cr;
		nextPutAll: 'END;'.
	
	trigger body: (body contents).
	
	^ trigger
]
