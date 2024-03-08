"
Transforms OntoUML generalizations into UML generalizations.
"
Class {
	#name : #MocoOntoUmlGeneralizationTransformationRule,
	#superclass : #MocoTransformationRule,
	#category : #'Moco-O2U-Rule'
}

{ #category : #accessing }
MocoOntoUmlGeneralizationTransformationRule >> execute [
	| gens |

	gens := (engine inModel elements select: [ :e | e isWrappingType: MocoOntoUmlGeneralization ]) select: [ :e | e meta outElements isEmpty ].
	
	gens do: [ :element |
		| outElement |
		outElement := MocoWrappedElement from: (self toUmlGeneralization: (element innerElement)).
		
		engine outModel elements add: outElement.
		
		element meta outElements add: outElement.
		element meta markProcessedBy: #MocoOntoUmlGeneralizationTransformationRule.
			
		engine outModel meta didChange: true.
	]
]

{ #category : #'private - processing' }
MocoOntoUmlGeneralizationTransformationRule >> findOutElementFor: anElement [
	^ (engine findOutElementsFor: anElement) first innerElement
]

{ #category : #accessing }
MocoOntoUmlGeneralizationTransformationRule >> priority [
	^ 50
]

{ #category : #'private - transforming' }
MocoOntoUmlGeneralizationTransformationRule >> toUmlGeneralization: aGeneralization [
	| uml |
	uml := MocoUmlGeneralization new.
	
	uml supertype: (self findOutElementFor: (aGeneralization supertype));
		subtype: (self findOutElementFor: (aGeneralization subtype)).
	
	^ uml
]
