"
Transforms mandatory association multiplicity OCL constraint to a CREATE PROCEDURE statement in a MySQL database.
"
Class {
	#name : 'MocoRdbMysqlOclMandatoryMultiplicityTransformationRule',
	#superclass : 'MocoTransformationRule',
	#category : 'Moco-D2SMysql-Rule',
	#package : 'Moco-D2SMysql',
	#tag : 'Rule'
}

{ #category : 'transforming' }
MocoRdbMysqlOclMandatoryMultiplicityTransformationRule >> execute [
	| ocls |
	ocls := engine input
		selectElementsOfKind: MocoOclRdbMandatoryMultiplicityConstraint
		notGuarded: #MocoRdbMysqlOclMandatoryMultiplicityTransformationRule.
	
	ocls do: [ :each |
		self generateProcedure: each.
		
		engine input guard: each with: #MocoRdbMysqlOclMandatoryMultiplicityTransformationRule
	]
]

{ #category : 'private - processing' }
MocoRdbMysqlOclMandatoryMultiplicityTransformationRule >> generateProcedure: aMocoOclRdbSpecialMultiplicityConstraint [
	| procedure body varName varName2 |
	procedure := MocoSqlMysqlCreateProcedure new.
	
	procedure name: (aMocoOclRdbSpecialMultiplicityConstraint name).
	
	body := String new writeStream.
	
	varName := MocoSqlMysqlEscaping escapeName: (MocoNamingUtils toShortName: (aMocoOclRdbSpecialMultiplicityConstraint context name)).
	varName2 := MocoNamingUtils toShortName: (aMocoOclRdbSpecialMultiplicityConstraint sourceTable name).
	varName2 := MocoUniqueNameGenerator at: [ :e | e = varName ] seed: varName2.
	varName2 := MocoSqlMysqlEscaping escapeName: varName2.

	body nextPutAll: 'IF EXISTS (';
		cr;
		nextPutAll: '  SELECT 1 FROM ';
		nextPutAll: (MocoSqlMysqlEscaping escapeName: (aMocoOclRdbSpecialMultiplicityConstraint context name));
		nextPutAll: ' ';
		nextPutAll: varName;
		nextPutAll: ' WHERE NOT EXISTS (';
		cr;
		nextPutAll: '    SELECT COUNT(1) FROM ';
		nextPutAll: (MocoSqlMysqlEscaping escapeName: (aMocoOclRdbSpecialMultiplicityConstraint sourceTable name));
		nextPutAll: ' ';
		nextPutAll: varName2;
		nextPutAll: ' WHERE ';
		nextPutAll: varName2;
		nextPutAll: '.';
		nextPutAll: (MocoSqlMysqlEscaping escapeName: (aMocoOclRdbSpecialMultiplicityConstraint sourceColumn name));
		nextPutAll: ' = ';
		nextPutAll: varName;
		nextPutAll: '.';
		nextPutAll: (MocoSqlMysqlEscaping escapeName: (aMocoOclRdbSpecialMultiplicityConstraint targetColumn name));
		nextPutAll: ')';
		cr;
		nextPutAll: ') THEN';
		cr;
		nextPutAll: '  SIGNAL SQLSTATE ''45000'' SET MESSAGE_TEXT = ';
		nextPutAll: (MocoSqlMysqlEscaping escapeLiteral: ('OCL constraint ' , (aMocoOclRdbSpecialMultiplicityConstraint name) , ' violated!'));
		nextPutAll: ';';
		cr;
		nextPutAll: 'END IF;'.

	procedure body: (body contents).

	procedure comment: 'call after INSERT or UPDATE or DELETE on ' , (MocoSqlMysqlEscaping escapeName: (aMocoOclRdbSpecialMultiplicityConstraint context name)) , ' or ' , (MocoSqlMysqlEscaping escapeName: (aMocoOclRdbSpecialMultiplicityConstraint sourceTable name)).

	engine addOutputElement: procedure withSource: aMocoOclRdbSpecialMultiplicityConstraint
]

{ #category : 'accessing' }
MocoRdbMysqlOclMandatoryMultiplicityTransformationRule >> priority [
	^ 80
]
