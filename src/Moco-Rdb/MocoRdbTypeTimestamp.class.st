"
Represents a TIMESTAMP data type in a relational database.
"
Class {
	#name : 'MocoRdbTypeTimestamp',
	#superclass : 'MocoRdbDataType',
	#category : 'Moco-Rdb-Model',
	#package : 'Moco-Rdb',
	#tag : 'Model'
}

{ #category : 'private - processing' }
MocoRdbTypeTimestamp >> acceptVisitor: aMocoRdbDataTypeVisitor [
	aMocoRdbDataTypeVisitor visitTimestamp: self
]

{ #category : 'accessing' }
MocoRdbTypeTimestamp >> typeName [
	^ 'TIMESTAMP'
]
