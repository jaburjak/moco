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
MocoOntoUmlClassTransformationRule >> execute [
	| kinds |

	kinds := (engine inModel elements select: [ :e | e isWrappingType: (self class modelSelector) ]) select: [ :e | e meta isNotProcessedBy: #MocoOntoUmlClassTransformationRule ].
	
	kinds do: [ :element |
		| outElement |
		outElement := MocoWrappedElement from: (self toUmlClass: element innerElement).
		
		engine outModel elements add: outElement.
		
		element meta outElements add: outElement.
		element meta markProcessedBy: #MocoOntoUmlClassTransformationRule.
			
		engine outModel meta didChange: true.
	]
]

{ #category : #accessing }
MocoOntoUmlClassTransformationRule >> priority [
	^ 95
]

{ #category : #'private - transforming' }
MocoOntoUmlClassTransformationRule >> toUmlClass: aMocoOntoUmlClass [
	| uml |
	
	uml := (self class umlClass) new.
	uml name: (aMocoOntoUmlClass name);
		abstract: (aMocoOntoUmlClass abstract).
	
	uml attributes addAll: (aMocoOntoUmlClass attributes).
	
	^ uml
]
