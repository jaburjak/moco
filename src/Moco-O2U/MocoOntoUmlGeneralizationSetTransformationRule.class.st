"
Transforms generalization sets from an OntoUML model to UML.
"
Class {
	#name : #MocoOntoUmlGeneralizationSetTransformationRule,
	#superclass : #MocoTransformationRule,
	#category : #'Moco-O2U-Rule'
}

{ #category : #accessing }
MocoOntoUmlGeneralizationSetTransformationRule >> executeOn: anEngine [
	| gens |

	gens := (anEngine inModel elements select: [ :e | e isWrappingType: MocoOntoUmlGeneralizationSet ]) select: [ :e | e meta isNotProcessedBy: #MocoOntoUmlGeneralizationSetTransformationRule ].
	
	gens do: [ :element |
		| outElement |
		outElement := MocoWrappedElement from: (self toUmlGeneralizationSet: (element innerElement) on: anEngine).
		
		anEngine outModel elements add: outElement.
		
		element meta outElements add: outElement.
		element meta markProcessedBy: #MocoOntoUmlGeneralizationSetTransformationRule.
		
		outElement innerElement covering ifTrue: [
			outElement innerElement members do: [ :each | each supertype abstract: true ]
		].
			
		anEngine outModel meta didChange: true.
	]
]

{ #category : #accessing }
MocoOntoUmlGeneralizationSetTransformationRule >> priority [
	^ 49
]

{ #category : #'private - transforming' }
MocoOntoUmlGeneralizationSetTransformationRule >> toUmlGeneralizationSet: aGeneralizationSet on: anEngine [
	| uml |
	uml := MocoUmlGeneralizationSet new.
	
	uml covering: (aGeneralizationSet covering);
		disjoint: (aGeneralizationSet disjoint);
		name: (aGeneralizationSet name).
	
	aGeneralizationSet members do: [ :each |
		| member |
		member := (anEngine findOutElementsFor: each) first innerElement.
		
		uml members add: member.
	].
	
	^ uml
]
