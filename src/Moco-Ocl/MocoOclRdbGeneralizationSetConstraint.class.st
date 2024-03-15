"
Represents a generalization set constraint in an RDB model.
"
Class {
	#name : #MocoOclRdbGeneralizationSetConstraint,
	#superclass : #MocoOclInvariant,
	#instVars : [
		'column',
		'tables',
		'values',
		'configurations'
	],
	#category : #'Moco-Ocl-Model'
}

{ #category : #accessing }
MocoOclRdbGeneralizationSetConstraint >> column [
	^ column
]

{ #category : #accessing }
MocoOclRdbGeneralizationSetConstraint >> column: aMocoRdbColumn [
	column := aMocoRdbColumn
]

{ #category : #accessing }
MocoOclRdbGeneralizationSetConstraint >> configurations [
	^ configurations
]

{ #category : #initialization }
MocoOclRdbGeneralizationSetConstraint >> initialize [
	super initialize.
	
	tables := OrderedCollection new.
	values := OrderedCollection new.
	configurations := OrderedCollection new
]

{ #category : #printing }
MocoOclRdbGeneralizationSetConstraint >> printTo: aStream [
	super printTo: aStream.
	
	values do: [ :each | self printVariant: each to: aStream ].
	
	aStream
		nextPutAll: '| ';
		nextPutAll: (' OR ' join: (values collect: [ :each | each , '_Instance' ]));
		cr;
		nextPutAll: '+----------------'
]

{ #category : #printing }
MocoOclRdbGeneralizationSetConstraint >> printVariant: aString to: aStream [
	values with: configurations do: [ :v :c |
		(v = aString) ifTrue: [
			aStream
				nextPutAll: '| def ';
				nextPutAll: v;
				nextPutAll: '_Instance: Boolean = self.';
				nextPutAll: (column name);
				nextPutAll: ' = ''';
				nextPutAll: v;
				nextPutAll: '''';
				cr.
			
			tables with: c do: [ :t :e |
				| varName |
				varName := t first name first asString asLowercase.

				aStream nextPutAll: '|   AND '.
				e ifFalse: [ aStream nextPutAll: 'NOT(' ].
				aStream
					nextPutAll: (t first name);
					nextPutAll: '.allInstances()->exists(';
					nextPutAll: varName;
					nextPutAll: ' | ';
					nextPutAll: varName;
					nextPutAll: '.';
					nextPutAll: (t last name);
					nextPutAll: ' = self.';
					nextPutAll: (column name);
					nextPutAll: ')'.
				e ifFalse: [ aStream nextPutAll: ')' ].
				aStream cr.
			]
		]
	]
]

{ #category : #accessing }
MocoOclRdbGeneralizationSetConstraint >> tables [
	^ tables
]

{ #category : #accessing }
MocoOclRdbGeneralizationSetConstraint >> values [
	^ values
]
