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
MocoRdbDataTypeVisitor >> visitBlob: aMocoRdbTypeBlob [
	self subclassResponsibility
]

{ #category : #visiting }
MocoRdbDataTypeVisitor >> visitBoolean: aMocoRdbTypeBoolean [
	self subclassResponsibility
]

{ #category : #visiting }
MocoRdbDataTypeVisitor >> visitCharacter: aMocoRdbTypeCharacter [
	self subclassResponsibility
]

{ #category : #visiting }
MocoRdbDataTypeVisitor >> visitDate: aMocoRdbTypeDate [
	self subclassResponsibility
]

{ #category : #visiting }
MocoRdbDataTypeVisitor >> visitDateTime: aMocoRdbTypeDateTime [
	self subclassResponsibility
]

{ #category : #visiting }
MocoRdbDataTypeVisitor >> visitDouble: aMocoRdbTypeDouble [
	self subclassResponsibility
]

{ #category : #visiting }
MocoRdbDataTypeVisitor >> visitInteger: aMocoRdbTypeInteger [
	self subclassResponsibility
]

{ #category : #visiting }
MocoRdbDataTypeVisitor >> visitTimestamp: aMocoRdbTypeTimestamp [
	self subclassResponsibility
]

{ #category : #visiting }
MocoRdbDataTypeVisitor >> visitVarchar: aMocoRdbTypeVarchar [
	self subclassResponsibility
]
