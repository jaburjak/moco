"
Transforms UML Classes into Oracle RDB tables.
"
Class {
	#name : #MocoUmlClassTransformationRule,
	#superclass : #MocoTransformationRule,
	#category : #'Moco-U2D-Rule'
}

{ #category : #accessing }
MocoUmlClassTransformationRule >> executeOn: anEngine [
	| classes |

	classes := (anEngine inModel elements select: [ :e | e isWrappingType: MocoUmlClass ]) select: [ :e | e meta isNotProcessedBy: #MocoUmlClassTransformationRule ].
	
	classes do: [ :element |
		| outElement |
		outElement := MocoWrappedElement from: (self toTable: element innerElement).
		
		anEngine outModel elements add: outElement.
		
		element meta outElements add: outElement.
		element meta markProcessedBy: #MocoUmlClassTransformationRule.
			
		anEngine outModel meta didChange: true.
	]
]

{ #category : #accessing }
MocoUmlClassTransformationRule >> priority [
	^ 100 
]

{ #category : #'as yet unclassified' }
MocoUmlClassTransformationRule >> toTable: anUmlClass [
	| table |
	table := MocoRdbOracleTable new.
	
	table name: (self transformClassName: anUmlClass name).
	
	^ table
]

{ #category : #'as yet unclassified' }
MocoUmlClassTransformationRule >> transformClassName: aString [
	^ MocoNamingUtils toUpperSnakeCase: aString
]
