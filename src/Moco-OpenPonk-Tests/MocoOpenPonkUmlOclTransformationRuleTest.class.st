Class {
	#name : #MocoOpenPonkUmlOclTransformationRuleTest,
	#superclass : #MocoTransformationRuleTestCase,
	#category : #'Moco-OpenPonk-Tests-Rule-Uml'
}

{ #category : #execution }
MocoOpenPonkUmlOclTransformationRuleTest >> execute [
	^ self execute: MocoOpenPonkUmlOclTransformationRule
]

{ #category : #tests }
MocoOpenPonkUmlOclTransformationRuleTest >> testOcl [
	| class class2 ocl ocl2 str |
	class := MocoUmlClass new name: 'TestClass'; yourself.
	ocl := MocoOpenPonkTestInvariant new name: 'First'; context: class; yourself.
	ocl2 := MocoOpenPonkTestInvariant new name: 'Second'; context: class; yourself.
	
	(engine input) addElement: class; addElement: ocl; addElement: ocl2.
	
	class2 := OPUMLClass new name: (class name); yourself.
	
	engine addOutputElement: class2 withSource: class.
	
	self execute.
	
	self assert: (engine output elements size) equals: 1.
	
	str := String new writeStream.
	ocl printOclTo: str.
	str cr; cr.
	ocl2 printOclTo: str.
	
	self assert: (class2 ownedComments size) equals: 1;
		assert: (class2 ownedComments first isKindOf: OPUMLComment);
		assert: (class2 ownedComments first body) equals: (str contents)
]
