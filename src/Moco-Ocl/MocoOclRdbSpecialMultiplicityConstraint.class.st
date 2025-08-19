"
Represents a special multiplicity constraint in an RDB model.
"
Class {
	#name : 'MocoOclRdbSpecialMultiplicityConstraint',
	#superclass : 'MocoOclInvariant',
	#instVars : [
		'lower',
		'upper',
		'targetColumn',
		'sourceTable',
		'sourceColumn'
	],
	#category : 'Moco-Ocl-Model',
	#package : 'Moco-Ocl',
	#tag : 'Model'
}

{ #category : 'accessing' }
MocoOclRdbSpecialMultiplicityConstraint >> lower [
	^ lower
]

{ #category : 'accessing' }
MocoOclRdbSpecialMultiplicityConstraint >> lower: aNumber [
	lower := aNumber
]

{ #category : 'printing' }
MocoOclRdbSpecialMultiplicityConstraint >> printOclTo: aStream [
	| varName |
	
	super printOclTo: aStream.
	
	varName := MocoNamingUtils toShortName: (sourceTable name).
	
	aStream
		nextPutAll: 'def count: Integer =';
		cr;
		nextPutAll: '  ';
		nextPutAll: (sourceTable name);
		nextPutAll: '.allInstances()->count(';
		nextPutAll: varName;
		nextPutAll: ' | ';
		nextPutAll: varName;
		nextPutAll: '.';
		nextPutAll: (sourceColumn name);
		nextPutAll: ' = self.';
		nextPutAll: (targetColumn name);
		nextPutAll: ')';
		cr.

	((lower isNotNil and: (upper isNotNil)) and: [ lower = upper ])
		ifTrue: [ aStream nextPutAll: 'count = ' , (lower asString) ]
		ifFalse: [
			lower ifNotNil: [
				aStream nextPutAll: (lower asString); nextPutAll: ' <= count'.
				
				upper ifNotNil: [ aStream nextPutAll: ' AND ' ]
			].

			upper ifNotNil: [
				aStream nextPutAll: 'count <= '; nextPutAll: (upper asString)
			]
		]
]

{ #category : 'accessing' }
MocoOclRdbSpecialMultiplicityConstraint >> sourceColumn [
	^ sourceColumn
]

{ #category : 'accessing' }
MocoOclRdbSpecialMultiplicityConstraint >> sourceColumn: aMocoRdbColumn [
	sourceColumn := aMocoRdbColumn
]

{ #category : 'accessing' }
MocoOclRdbSpecialMultiplicityConstraint >> sourceTable [
	^ sourceTable
]

{ #category : 'accessing' }
MocoOclRdbSpecialMultiplicityConstraint >> sourceTable: aMocoRdbTable [
	sourceTable := aMocoRdbTable
]

{ #category : 'accessing' }
MocoOclRdbSpecialMultiplicityConstraint >> targetColumn [
	^ targetColumn
]

{ #category : 'accessing' }
MocoOclRdbSpecialMultiplicityConstraint >> targetColumn: aMocoRdbColumn [
	targetColumn := aMocoRdbColumn
]

{ #category : 'accessing' }
MocoOclRdbSpecialMultiplicityConstraint >> upper [
	^ upper
]

{ #category : 'accessing' }
MocoOclRdbSpecialMultiplicityConstraint >> upper: aNumber [
	upper := aNumber
]
