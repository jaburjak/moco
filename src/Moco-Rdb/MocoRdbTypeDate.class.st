"
Represents a DATE data type in a relational database.
"
Class {
	#name : 'MocoRdbTypeDate',
	#superclass : 'MocoRdbDataType',
	#category : 'Moco-Rdb-Model',
	#package : 'Moco-Rdb',
	#tag : 'Model'
}

{ #category : 'private - processing' }
MocoRdbTypeDate >> acceptVisitor: aMocoRdbDataTypeVisitor [
	aMocoRdbDataTypeVisitor visitDate: self
]

{ #category : 'accessing' }
MocoRdbTypeDate >> typeName [
	^ 'DATE'
]
