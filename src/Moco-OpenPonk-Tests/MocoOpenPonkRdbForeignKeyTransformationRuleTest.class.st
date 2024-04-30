Class {
	#name : #MocoOpenPonkRdbForeignKeyTransformationRuleTest,
	#superclass : #MocoTransformationRuleTestCase,
	#instVars : [
		'source',
		'target'
	],
	#category : #'Moco-OpenPonk-Tests-Rule-Rdb'
}

{ #category : #'private - processing' }
MocoOpenPonkRdbForeignKeyTransformationRuleTest >> execute [
	^ self execute: MocoOpenPonkRdbForeignKeyTransformationRule
]

{ #category : #running }
MocoOpenPonkRdbForeignKeyTransformationRuleTest >> setUp [
	super setUp.
	
	source := { MocoRdbTable new name: 'SOURCE'; yourself. OPUMLClass new name: 'SOURCE'; yourself }.
	
	engine input addElement: (source first).
	engine addOutputElement: (source second) withSource: (source first).
	
	target := { MocoRdbTable new name: 'TARGET'; yourself. OPUMLClass new name: 'TARGET'; yourself }.
	
	target first columns add: (MocoRdbColumn new name: 'T_ID'; type: (MocoRdbTypeInteger new); yourself).
	target second ownedAttributes add: (OPUMLProperty new name: 'T_ID'; yourself).
	
	engine input addElement: (target first).
	engine addOutputElement: (target second) withSource: (target first)
]

{ #category : #tests }
MocoOpenPonkRdbForeignKeyTransformationRuleTest >> testForeignKey [
	| col fk op |
	col := MocoRdbColumn new name: 'TGT'; type: (MocoRdbTypeInteger new); nullable: false; yourself.
	source first columns add: col.
	source second ownedAttributes add: (OPUMLProperty new name: 'TGT'; type: (OPUMLPrimitiveType new name: 'Integer'; yourself); yourself).
	fk := MocoRdbForeignKey new name: 'FK'; yourself.
	fk columns add: col.
	fk referencedTable: (target first).
	fk referencedColumns add: (target first columns first).
	
	source first constraints add: fk.
	
	self execute.
	
	op := engine output elements select: [ :each | each isKindOf: OPUMLAssociation ].
	
	self assert: (op size) equals: 1.
	
	op := op first.
	
	self assert: (op name) equals: ('«FK» (' , (col name) , '=' , (fk referencedColumns first name) , ')');
		assert: (op memberEnds size) equals: 2;
		assert: (op memberEnds first type) identicalTo: (source second);
		assert: (op memberEnds first lowerValue value) equals: 0;
		assert: (op memberEnds first upperValue value) equals: '*';
		assert: (op memberEnds second type) identicalTo: (target second);
		assert: (op memberEnds second lowerValue value) equals: 1;
		assert: (op memberEnds second upperValue value) equals: 1;
		assert: (op ownedEnds size) equals: 1;
		assert: (op ownedEnds first) identicalTo: (op memberEnds first);
		assert: (source second ownedAttributes anySatisfy: [ :each | (each type) == (target second) ])
]

{ #category : #tests }
MocoOpenPonkRdbForeignKeyTransformationRuleTest >> testMandatoryMultiplicity [
	| fk ocl op |
	source first columns add: (MocoRdbColumn new name: 'TGT'; type: (MocoRdbTypeInteger new); yourself).
	source second ownedAttributes add: (OPUMLProperty new name: 'TGT'; type: (OPUMLPrimitiveType new name: 'Integer'; yourself); yourself).
	fk := MocoRdbForeignKey new name: 'FK'; yourself.
	fk columns add: (source first columns first).
	fk referencedTable: (target first).
	fk referencedColumns add: (target first columns first).
	source first constraints add: fk.
	ocl := MocoOclRdbMandatoryMultiplicityConstraint new name: 'MUL'; context: (fk referencedTable); sourceColumn: (fk columns first); sourceTable: (source first); targetColumn: (fk referencedColumns first).
	
	engine input addElement: ocl.
	
	self execute.
	
	op := engine output elements detect: [ :each | each isKindOf: OPUMLAssociation ].
	
	self assert: (op memberEnds first lowerValue value) equals: 1;
		assert: (op memberEnds first upperValue value) equals: '*'
]

{ #category : #tests }
MocoOpenPonkRdbForeignKeyTransformationRuleTest >> testNullable [
	| fk op |
	source first columns add: (MocoRdbColumn new name: 'TGT'; type: (MocoRdbTypeInteger new); nullable: true; yourself).
	source second ownedAttributes add: (OPUMLProperty new name: 'TGT'; type: (OPUMLPrimitiveType new name: 'Integer'; yourself); yourself).
	fk := MocoRdbForeignKey new name: 'FK'; yourself.
	fk columns add: (source first columns first).
	fk referencedTable: (target first).
	fk referencedColumns add: (target first columns first).
	source first constraints add: fk.
	
	self execute.
	
	op := engine output elements detect: [ :each | each isKindOf: OPUMLAssociation ].
	
	self assert: (op memberEnds second lowerValue value) equals: 0;
		assert: (op memberEnds second upperValue value) equals: 1
]

{ #category : #tests }
MocoOpenPonkRdbForeignKeyTransformationRuleTest >> testSpecialMultiplicity [
	| fk ocl op |
	source first columns add: (MocoRdbColumn new name: 'TGT'; type: (MocoRdbTypeInteger new); yourself).
	source second ownedAttributes add: (OPUMLProperty new name: 'TGT'; type: (OPUMLPrimitiveType new name: 'Integer'; yourself); yourself).
	fk := MocoRdbForeignKey new name: 'FK'; yourself.
	fk columns add: (source first columns first).
	fk referencedTable: (target first).
	fk referencedColumns add: (target first columns first).
	source first constraints add: fk.
	ocl := MocoOclRdbSpecialMultiplicityConstraint new name: 'MUL'; context: (fk referencedTable); sourceColumn: (fk columns first); sourceTable: (source first); targetColumn: (fk referencedColumns first); lower: 3; upper: 4.
	
	engine input addElement: ocl.
	
	self execute.
	
	op := engine output elements detect: [ :each | each isKindOf: OPUMLAssociation ].
	
	self assert: (op memberEnds first lowerValue value) equals: 3;
		assert: (op memberEnds first upperValue value) equals: 4
]
