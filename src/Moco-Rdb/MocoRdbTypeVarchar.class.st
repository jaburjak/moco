"
Represents a VARCHAR data type.
"
Class {
	#name : #MocoRdbTypeVarchar,
	#superclass : #MocoRdbDataType,
	#instVars : [
		'length'
	],
	#category : #'Moco-Rdb-Model'
}

{ #category : #'private - processing' }
MocoRdbTypeVarchar >> acceptVisitor: aMocoRdbDataTypeVisitor [
	aMocoRdbDataTypeVisitor visitVarchar: self
]

{ #category : #initialization }
MocoRdbTypeVarchar >> initialize [
	super initialize.
	
	length := 4000.
]

{ #category : #accessing }
MocoRdbTypeVarchar >> length [
	^ length
]

{ #category : #accessing }
MocoRdbTypeVarchar >> length: aNumber [
	length := aNumber
]

{ #category : #accessing }
MocoRdbTypeVarchar >> typeDefinition [
	^ (self typeName) , '(' , (length asString) , ')'
]

{ #category : #accessing }
MocoRdbTypeVarchar >> typeName [
	^ 'VARCHAR'
]
