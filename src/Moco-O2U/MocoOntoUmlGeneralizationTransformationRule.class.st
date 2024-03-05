"
Transforms OntoUML generalizations into UML generalizations.
"
Class {
	#name : #MocoOntoUmlGeneralizationTransformationRule,
	#superclass : #MocoTransformationRule,
	#category : #'Moco-O2U-Rule'
}

{ #category : #accessing }
MocoOntoUmlGeneralizationTransformationRule >> executeOn: anEngine [
	| gens |

	gens := (anEngine inModel elements select: [ :e | e isWrappingType: MocoOntoUmlGeneralization ]) select: [ :e | e meta isNotProcessedBy: #MocoOntoUmlGeneralizationTransformationRule ].
	
	gens do: [ :element |
		| outElement |
		outElement := MocoWrappedElement from: (self toUmlGeneralization: (element innerElement) on: anEngine).
		
		anEngine outModel elements add: outElement.
		
		element meta outElements add: outElement.
		element meta markProcessedBy: #MocoOntoUmlGeneralizationTransformationRule.
			
		anEngine outModel meta didChange: true.
	]
]

{ #category : #'private - processing' }
MocoOntoUmlGeneralizationTransformationRule >> findOutElementFor: anElement on: anEngine [
	^ (anEngine findOutElementsFor: anElement) first innerElement
]

{ #category : #accessing }
MocoOntoUmlGeneralizationTransformationRule >> priority [
	^ 50
]

{ #category : #'private - transforming' }
MocoOntoUmlGeneralizationTransformationRule >> toUmlGeneralization: aGeneralization on: anEngine [
	| uml |
	uml := MocoUmlGeneralization new.
	
	uml supertype: (self findOutElementFor: (aGeneralization supertype) on: anEngine);
		subtype: (self findOutElementFor: (aGeneralization subtype) on: anEngine).
	
	^ uml
]
