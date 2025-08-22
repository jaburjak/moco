"
Represents a CHAR data type in a Relational database.
"
Class {
	#name : 'MocoRdbTypeCharacter',
	#superclass : 'MocoRdbDataType',
	#category : 'Moco-Rdb-Model',
	#package : 'Moco-Rdb',
	#tag : 'Model'
}

{ #category : 'private - processing' }
MocoRdbTypeCharacter >> acceptVisitor: aMocoRdbDataTypeVisitor [
	aMocoRdbDataTypeVisitor visitCharacter: self
]

{ #category : 'accessing' }
MocoRdbTypeCharacter >> typeName [
	^ 'CHAR'
]
