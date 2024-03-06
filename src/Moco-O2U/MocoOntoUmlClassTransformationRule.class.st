"
Base class for transformation rules that transform OntoUML classes into UML classes.
"
Class {
	#name : #MocoOntoUmlClassTransformationRule,
	#superclass : #MocoTransformationRule,
	#category : #'Moco-O2U-Rule'
}

{ #category : #'private - accessing' }
MocoOntoUmlClassTransformationRule class >> modelSelector [
	^ MocoOntoUmlClass
]

{ #category : #'private - accessing' }
MocoOntoUmlClassTransformationRule class >> umlClass [
	^ MocoUmlClass
]

{ #category : #transforming }
MocoOntoUmlClassTransformationRule >> executeOn: anEngine [
	| kinds |

	kinds := (anEngine inModel elements select: [ :e | e isWrappingType: (self class modelSelector) ]) select: [ :e | e meta isNotProcessedBy: #MocoOntoUmlClassTransformationRule ].
	
	kinds do: [ :element |
		| outElement |
		outElement := MocoWrappedElement from: (self toUmlClass: element innerElement).
		
		anEngine outModel elements add: outElement.
		
		element meta outElements add: outElement.
		element meta markProcessedBy: #MocoOntoUmlClassTransformationRule.
			
		anEngine outModel meta didChange: true.
	]
]

{ #category : #accessing }
MocoOntoUmlClassTransformationRule >> priority [
	^ 95
]

{ #category : #'private - transforming' }
MocoOntoUmlClassTransformationRule >> toUmlClass: aKind [
	| uml |
	
	uml := (self class umlClass) new.
	uml name: (aKind name);
		abstract: (aKind abstract).
	
	uml attributes addAll: (aKind attributes).
	
	^ uml
]
