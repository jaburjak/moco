"
Transforms OntoUML Kinds into UML Classes.
"
Class {
	#name : #MocoOntoUmlKindTransformationRule,
	#superclass : #MocoTransformationRule,
	#category : #'Moco-O2U-Rule'
}

{ #category : #accessing }
MocoOntoUmlKindTransformationRule >> executeOn: anEngine [
	| kinds |

	kinds := (anEngine inModel elements select: [ :e | e isWrappingType: MocoOntoUmlKind ]) select: [ :e | e meta outElements isEmpty ].
	
	kinds do: [ :element |
		| outElement |
		outElement := MocoWrappedElement from: (self toUmlClass: element innerElement).
		
		anEngine outModel elements add: outElement.
		
		element meta outElements add: outElement.
		element meta exhausted: true.
			
		anEngine outModel meta didChange: true.
	]
]

{ #category : #accessing }
MocoOntoUmlKindTransformationRule >> priority [
	^ 100
]

{ #category : #'as yet unclassified' }
MocoOntoUmlKindTransformationRule >> toUmlClass: aKind [
	| uml |
	
	uml := MocoUmlClass new.
	uml name: (aKind name);
		abstract: (aKind abstract).
	
	^ uml
]