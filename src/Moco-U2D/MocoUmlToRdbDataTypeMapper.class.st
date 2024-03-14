"
Maps attribute data types in a UML model to database column data types.
"
Class {
	#name : #MocoUmlToRdbDataTypeMapper,
	#superclass : #Object,
	#instVars : [
		'mapping'
	],
	#category : #'Moco-U2D-Utils'
}

{ #category : #initialization }
MocoUmlToRdbDataTypeMapper >> initialize [
	super initialize.
	
	mapping := Dictionary new.
	
	mapping
		at: #String put: MocoRdbTypeVarchar;
		at: #int put: MocoRdbTypeInteger;
		at: #Integer put: MocoRdbTypeInteger;
		at: #Date put: MocoRdbTypeDate.
]

{ #category : #transforming }
MocoUmlToRdbDataTypeMapper >> map: aString [
	^ mapping at: (aString asByteString) ifAbsent: [ nil ]
]
