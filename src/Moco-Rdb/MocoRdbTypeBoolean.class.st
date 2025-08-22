"
Represents a BOOLEAN data type in a relational database.
"
Class {
	#name : 'MocoRdbTypeBoolean',
	#superclass : 'MocoRdbDataType',
	#category : 'Moco-Rdb-Model',
	#package : 'Moco-Rdb',
	#tag : 'Model'
}

{ #category : 'private - processing' }
MocoRdbTypeBoolean >> acceptVisitor: aMocoRdbDataTypeVisitor [
	aMocoRdbDataTypeVisitor visitBoolean: self
]

{ #category : 'accessing' }
MocoRdbTypeBoolean >> typeName [
	^ 'BOOLEAN'
]
