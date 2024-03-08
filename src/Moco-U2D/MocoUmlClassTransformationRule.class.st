"
Transforms UML Classes into Oracle RDB tables.
"
Class {
	#name : #MocoUmlClassTransformationRule,
	#superclass : #MocoTransformationRule,
	#category : #'Moco-U2D-Rule'
}

{ #category : #transforming }
MocoUmlClassTransformationRule >> execute [
	| classes |

	classes := (engine inModel elements select: [ :e | e isWrappingType: MocoUmlClass ]) select: [ :e | e meta isNotProcessedBy: #MocoUmlClassTransformationRule ].
	
	classes do: [ :element |
		| outElement |
		outElement := MocoWrappedElement from: (self toTable: element innerElement).
		
		engine outModel elements add: outElement.
		
		element meta outElements add: outElement.
		element meta markProcessedBy: #MocoUmlClassTransformationRule.
			
		engine outModel meta didChange: true.
	]
]

{ #category : #accessing }
MocoUmlClassTransformationRule >> priority [
	^ 100 
]

{ #category : #'as yet unclassified' }
MocoUmlClassTransformationRule >> toTable: anUmlClass [
	| table |
	table := MocoRdbTable new.
	
	table name: (self transformClassName: anUmlClass name).
	
	^ table
]

{ #category : #'as yet unclassified' }
MocoUmlClassTransformationRule >> transformClassName: aString [
	^ MocoNamingUtils toUpperSnakeCase: aString
]
