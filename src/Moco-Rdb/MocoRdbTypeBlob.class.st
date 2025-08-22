"
Represents a BINARY LARGE OBJECT data type in a relational database.
"
Class {
	#name : 'MocoRdbTypeBlob',
	#superclass : 'MocoRdbDataType',
	#category : 'Moco-Rdb-Model',
	#package : 'Moco-Rdb',
	#tag : 'Model'
}

{ #category : 'private - processing' }
MocoRdbTypeBlob >> acceptVisitor: aMocoRdbDataTypeVisitor [
	aMocoRdbDataTypeVisitor visitBlob: self
]

{ #category : 'accessing' }
MocoRdbTypeBlob >> typeName [
	^ 'BLOB'
]
