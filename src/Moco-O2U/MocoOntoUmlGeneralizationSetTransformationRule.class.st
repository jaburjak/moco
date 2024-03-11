"
Transforms generalization sets from an OntoUML model to UML.
"
Class {
	#name : #MocoOntoUmlGeneralizationSetTransformationRule,
	#superclass : #MocoTransformationRule,
	#category : #'Moco-O2U-Rule'
}

{ #category : #accessing }
MocoOntoUmlGeneralizationSetTransformationRule >> execute [
	| gens |

	gens := (engine inModel elements select: [ :e | e isWrappingType: MocoOntoUmlGeneralizationSet ])
		select: [ :e | (e meta isNotProcessedBy: #MocoOntoUmlGeneralizationSetTransformationRule) and: [ e meta outElements isEmpty ] ].
	
	gens do: [ :element |
		| uml outElement |
		uml := self toUmlGeneralizationSet: (element innerElement).
		
		uml ifNotNil: [
			outElement := MocoWrappedElement from: uml.

			engine outModel elements add: outElement.

			element meta outElements add: outElement.

			outElement innerElement covering ifTrue: [
				outElement innerElement members do: [ :each | each supertype abstract: true ]
			].

			engine outModel meta didChange: true.
		].
	
		element meta markProcessedBy: #MocoOntoUmlGeneralizationSetTransformationRule.
	]
]

{ #category : #accessing }
MocoOntoUmlGeneralizationSetTransformationRule >> priority [
	^ 49
]

{ #category : #'private - transforming' }
MocoOntoUmlGeneralizationSetTransformationRule >> toUmlGeneralizationSet: aGeneralizationSet [
	| uml |
	uml := MocoUmlGeneralizationSet new.
	
	uml covering: (aGeneralizationSet covering);
		disjoint: (aGeneralizationSet disjoint);
		name: (aGeneralizationSet name).
	
	aGeneralizationSet members do: [ :each |
		| outElems |
		outElems := (engine findOutElementsFor: each) select: [ :e | e isWrappingType: MocoUmlGeneralization ].
		
		outElems ifNotEmpty: [ uml members add: (outElems first innerElement) ].
	].

	uml members ifEmpty: [ ^ nil ]. "Members of the OntoUML generalization set are not present in the UML model."
	                                "They were probably transformed into a different construct, making this generalization"
	^ uml                           "set unnecessary."
]
