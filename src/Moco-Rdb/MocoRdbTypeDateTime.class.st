"
Represents a DATETIME data type in a relational database.
"
Class {
	#name : #MocoRdbTypeDateTime,
	#superclass : #MocoRdbDataType,
	#category : #'Moco-Rdb-Model'
}

{ #category : #'private - processing' }
MocoRdbTypeDateTime >> acceptVisitor: aMocoRdbDataTypeVisitor [
	aMocoRdbDataTypeVisitor visitDateTime: self
]

{ #category : #accessing }
MocoRdbTypeDateTime >> typeName [
	^ 'DATETIME'
]
