"
Transforms a table element from a relational model into OpenPonk’s class model.
"
Class {
	#name : #MocoOpenPonkRdbTableTransformationRule,
	#superclass : #MocoTransformationRule,
	#classVars : [
		'DataTypeCache'
	],
	#category : #'Moco-OpenPonk-Rule-Rdb'
}

{ #category : #transforming }
MocoOpenPonkRdbTableTransformationRule >> execute [
	| tables |
	tables := engine input
		selectElementsOfKind: MocoRdbTable
		notGuarded: #MocoOpenPonkRdbTableTransformationRule.
	
	tables do: [ :each | self transformTable: each ]
]

{ #category : #accessing }
MocoOpenPonkRdbTableTransformationRule >> priority [
	^ 100
]

{ #category : #'private - transforming' }
MocoOpenPonkRdbTableTransformationRule >> toOpenPonkElement: aMocoRdbTable [
	"Creates an OpenPonk class from the given Moco database table."
	
	| op |
	op := OPUMLClass new.
	
	op name: (aMocoRdbTable name).
	
	aMocoRdbTable columns do: [ :each | op ownedAttributes add: (self transformColumn: each) ].
	aMocoRdbTable constraints do: [ :each | op ownedOperations add: (self transformConstraint: each) ].
	
	^ op
]

{ #category : #'private - transforming' }
MocoOpenPonkRdbTableTransformationRule >> transformColumn: aMocoRdbColumn [
	"Creates an OpenPonk class attribute from the given database column."
	
	| prop |
	prop := OPUMLProperty new.
	
	prop name: (aMocoRdbColumn name).
	
	aMocoRdbColumn type ifNotNil: [
		prop type: (self class toOpenPonkDataType: aMocoRdbColumn)
	].
	
	prop upperValue: (OPUMLLiteralUnlimitedNatural new value: 1).
		
	^ prop
]

{ #category : #'private - transforming' }
MocoOpenPonkRdbTableTransformationRule >> transformConstraint: aMocoRdbConstraint [
	"Creates an OpenPonk class operation from the given database constraint."
	
	| op str parts |
	op := OPUMLOperation new.
	
	str := String new writeStream.
	aMocoRdbConstraint printTo: str.
	
	parts := ((str contents copyReplaceAll: '<<' with: '«') copyReplaceAll: '>>' with: '»') splitOn: '('.
	
	op name: parts first.
	
	(((parts size) > 1) and: [ (parts second size) > 1 ]) ifTrue:  [
		op ownedParameters add: (OPUMLParameter new name: (('(' join: (parts allButFirst: 1)) allButLast: 1); yourself)
	].
	
	^ op
]

{ #category : #'private - transforming' }
MocoOpenPonkRdbTableTransformationRule >> transformTable: aMocoRdbTable [
	"Transforms a database table to a class element."
	
	| class |
	class := self toOpenPonkElement: aMocoRdbTable.
	
	engine addOutputElement: class withSource: aMocoRdbTable.
	engine input guard: aMocoRdbTable with: #MocoOpenPonkRdbTableTransformationRule
]
