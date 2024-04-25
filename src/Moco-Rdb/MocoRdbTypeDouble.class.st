"
Represents a DOUBLE PRECISION data type in a relational database.
"
Class {
	#name : #MocoRdbTypeDouble,
	#superclass : #MocoRdbDataType,
	#category : #'Moco-Rdb-Model'
}

{ #category : #'private - processing' }
MocoRdbTypeDouble >> acceptVisitor: aMocoRdbDataTypeVisitor [
	aMocoRdbDataTypeVisitor visitDouble: self
]

{ #category : #accessing }
MocoRdbTypeDouble >> typeName [
	^ 'DOUBLE'
]
