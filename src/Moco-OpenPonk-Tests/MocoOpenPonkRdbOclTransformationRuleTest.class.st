Class {
	#name : #MocoOpenPonkRdbOclTransformationRuleTest,
	#superclass : #MocoTransformationRuleTestCase,
	#category : #'Moco-OpenPonk-Tests-Rule-Rdb'
}

{ #category : #'private - processing' }
MocoOpenPonkRdbOclTransformationRuleTest >> execute [
	^ self execute: MocoOpenPonkRdbOclTransformationRule
]

{ #category : #tests }
MocoOpenPonkRdbOclTransformationRuleTest >> testOcl [
	| table class ocl ocl2 str |
	table := MocoRdbTable new name: 'TEST'; yourself.
	class := OPUMLClass new name: (table name); yourself.
	ocl := MocoOpenPonkTestInvariant new name: 'First'; context: table; yourself.
	ocl2 := MocoOpenPonkTestInvariant new name: 'Second'; context: table; yourself.
	
	(engine input) addElement: table; addElement: ocl; addElement: ocl2.
	engine addOutputElement: class withSource: table.
	
	self execute.
	
	self assert: (engine output elements size) equals: 1.
	
	str := String new writeStream.
	ocl printOclTo: str.
	str cr; cr.
	ocl2 printOclTo: str.
	
	self assert: (class ownedComments size) equals: 1;
		assert: (class ownedComments first isKindOf: OPUMLComment);
		assert: (class ownedComments first body) equals: (str contents)
]
