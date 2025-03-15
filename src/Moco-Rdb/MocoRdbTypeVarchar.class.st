"
Represents a VARCHAR data type.

When length is nil, corresponds to a type with unlimited variable length.
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
