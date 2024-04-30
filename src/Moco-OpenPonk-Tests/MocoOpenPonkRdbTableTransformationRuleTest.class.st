Class {
	#name : #MocoOpenPonkRdbTableTransformationRuleTest,
	#superclass : #MocoTransformationRuleTestCase,
	#category : #'Moco-OpenPonk-Tests-Rule-Rdb'
}

{ #category : #'private - processing' }
MocoOpenPonkRdbTableTransformationRuleTest >> execute [
	^ self execute: MocoOpenPonkRdbTableTransformationRule
]

{ #category : #tests }
MocoOpenPonkRdbTableTransformationRuleTest >> testTable [
	| table cols cons op |
	table := MocoRdbTable new name: 'TABLE'; yourself.
	cols := OrderedCollection
		with: (MocoRdbColumn new name: 'ID'; nullable: false; type: (MocoRdbTypeInteger new); yourself)
		with: (MocoRdbColumn new name: 'COL'; nullable: true; type: (MocoRdbTypeBoolean new); yourself).
	table columns addAll: cols.
	cons := OrderedCollection
		with: (MocoRdbPrimaryKey new name: 'PK'; yourself)
		with: (MocoRdbUniqueKey new name: 'UK'; yourself).
	cons first columns add: (cols first).
	(cons second columns) add: (cols first); add: (cols second).
	table constraints addAll: cons.
	
	engine input addElement: table.
	
	self execute.
	
	self assert: (engine output elements size) equals: 1.
	
	op := engine output elements first.
	
	self assert: (op isKindOf: OPUMLClass);
		assert: (op name) equals: (table name);
		assert: (op ownedAttributes size) equals: (table columns size);
		assert: (op ownedOperations size) equals: (table constraints size).
	
	table columns do: [ :each |
		| attr |
		self assert: (op ownedAttributes anySatisfy: [ :e | (e name) = (each name) ]).
		attr := op ownedAttributes detect: [ :e | (e name) = (each name) ].
		self assert: (attr type name) equals: (each type typeDefinition);
			assert: (attr upperValue value) equals: 1;
			assert: (attr lowerValue value) equals: (each nullable ifTrue: [ 0 ] ifFalse: [ 1 ])
	].
	
	table constraints do: [ :each |
		| oper |
		oper := op ownedOperations select: [ :e | (((each isKindOf: MocoRdbPrimaryKey) ifTrue: [ '«PK»' ] ifFalse: [ '«unique»' ]) , ' ' , (each name)) = (e name) ].
		self assert: (oper size) equals: 1.
		oper := oper first.
		self assert: (oper ownedParameters size) equals: 1;
			assert: (oper ownedParameters first name) equals: (',' join: (each columns collect: [ :e | e name ])).
	]
]
