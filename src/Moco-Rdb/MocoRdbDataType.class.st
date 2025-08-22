"
Base class for database column data types.
"
Class {
	#name : 'MocoRdbDataType',
	#superclass : 'Object',
	#category : 'Moco-Rdb-Model',
	#package : 'Moco-Rdb',
	#tag : 'Model'
}

{ #category : 'instance creation' }
MocoRdbDataType class >> new [
	(self asString = 'MocoRdbDataType') ifTrue: [ ^ self subclassResponsibility ] ifFalse: [ ^ super new ]
]

{ #category : 'processing' }
MocoRdbDataType >> accept: aMocoRdbDataTypeVisitor [
	self acceptVisitor: aMocoRdbDataTypeVisitor
]

{ #category : 'private - processing' }
MocoRdbDataType >> acceptVisitor: aMocoRdbDataTypeVisitor [
	self subclassResponsibility
]

{ #category : 'accessing' }
MocoRdbDataType >> typeDefinition [
	"Returns type definition, e.g. VARCHAR(50)."

	^ self typeName
]

{ #category : 'accessing' }
MocoRdbDataType >> typeName [
	"Returns type name, e.g. VARCHAR."

	^ self subclassResponsibility
]
