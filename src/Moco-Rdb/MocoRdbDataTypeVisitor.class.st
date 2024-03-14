"
Visitor interface for database column data types.
"
Class {
	#name : #MocoRdbDataTypeVisitor,
	#superclass : #Object,
	#category : #'Moco-Rdb-Utils'
}

{ #category : #'instance creation' }
MocoRdbDataTypeVisitor class >> new [
	(self asString = 'MocoRdbDataTypeVisitor') ifTrue: [ ^ self subclassResponsibility ] ifFalse: [ ^ super new ]
]

{ #category : #visiting }
MocoRdbDataTypeVisitor >> visitDate: aMocoRdbTypeDate [
	self subclassResponsibility
]

{ #category : #visiting }
MocoRdbDataTypeVisitor >> visitInteger: aMocoRdbTypeInteger [
	self subclassResponsibility
]

{ #category : #visiting }
MocoRdbDataTypeVisitor >> visitVarchar: aMocoRdbTypeVarchar [
	self subclassResponsibility
]
