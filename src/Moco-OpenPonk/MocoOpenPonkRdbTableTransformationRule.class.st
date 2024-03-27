"
Transforms a table element from a relational model into OpenPonk’s class model.
"
Class {
	#name : #MocoOpenPonkRdbTableTransformationRule,
	#superclass : #MocoTransformationRule,
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
	aMocoRdbTable constraints do: [ :each | op ownedAttributes add: (self transformConstraint: each) ].
	
	^ op
]

{ #category : #'private - transforming' }
MocoOpenPonkRdbTableTransformationRule >> transformColumn: aMocoRdbColumn [
	"Creates an OpenPonk class attribute from the given database column."
	
	| prop |
	prop := OPUMLProperty new.
	
	prop name: (aMocoRdbColumn name).
	
	aMocoRdbColumn type ifNotNil: [
		prop type: (OPUMLPrimitiveType new).
		prop type name: (aMocoRdbColumn type typeDefinition)
	].
	
	aMocoRdbColumn nullable
		ifTrue: [ prop type name: ((prop type name) , ' NULLABLE') ].
	
	prop upperValue: (OPUMLLiteralUnlimitedNatural new value: 1).
		
	^ prop
]

{ #category : #'private - transforming' }
MocoOpenPonkRdbTableTransformationRule >> transformConstraint: aMocoRdbConstraint [
	"Creates an OpenPonk class attribute from the given database constraint that visually looks like the original constraint definition."
	
	| prop name |
	prop := OPUMLProperty new.
	
	name := String new writeStream.
	aMocoRdbConstraint printTo: name.
	
	prop name: (' ' , (name contents)). "Insert a non-breaking space at the beginning to force OpenPonk to put the property"
	                                    "after all other properties when rendering the diagram."
		
	^ prop
]

{ #category : #'private - transforming' }
MocoOpenPonkRdbTableTransformationRule >> transformTable: aMocoRdbTable [
	"Transforms a database table to a class element."
	
	| class |
	class := self toOpenPonkElement: aMocoRdbTable.
	
	engine addOutputElement: class withSource: aMocoRdbTable.
	engine input guard: aMocoRdbTable with: #MocoOpenPonkRdbTableTransformationRule
]
