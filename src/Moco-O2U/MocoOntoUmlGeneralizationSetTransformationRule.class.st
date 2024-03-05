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
		| uml outElement |
		uml := self toUmlGeneralizationSet: (element innerElement) on: anEngine.
		
		uml ifNotNil: [
			outElement := MocoWrappedElement from: (self toUmlGeneralizationSet: (element innerElement) on: anEngine).

			anEngine outModel elements add: outElement.

			element meta outElements add: outElement.

			outElement innerElement covering ifTrue: [
				outElement innerElement members do: [ :each | each supertype abstract: true ]
			].

			anEngine outModel meta didChange: true.
		].
	
		element meta markProcessedBy: #MocoOntoUmlGeneralizationSetTransformationRule.
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
		| outElems |
		outElems := anEngine findOutElementsFor: each.
		
		outElems ifNotEmpty: [ uml members add: (outElems first innerElement) ].
	].

	uml members ifEmpty: [ ^ nil ]. "Members of the OntoUML generalization set are not present in the UML model."
	                                "They were probably transformed into a different construct, making this generalization"
	^ uml                           "set unnecessary."
]
