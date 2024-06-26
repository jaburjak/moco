"
Represents an INTEGER database data type.
"
Class {
	#name : #MocoRdbTypeInteger,
	#superclass : #MocoRdbDataType,
	#category : #'Moco-Rdb-Model'
}

{ #category : #'private - processing' }
MocoRdbTypeInteger >> acceptVisitor: aMocoRdbDataTypeVisitor [
	aMocoRdbDataTypeVisitor visitInteger: self
]

{ #category : #accessing }
MocoRdbTypeInteger >> typeName [
	^ 'INTEGER'
]
