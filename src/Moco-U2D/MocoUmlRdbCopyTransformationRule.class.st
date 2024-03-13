"
Copies UML model elements without transformations.
"
Class {
	#name : #MocoUmlRdbCopyTransformationRule,
	#superclass : #MocoTransformationRule,
	#category : #'Moco-U2D-Rule-Preprocess'
}

{ #category : #transforming }
MocoUmlRdbCopyTransformationRule >> execute [
	| elements |
	elements := engine inModel elements reject: [ :each | each meta isProcessedBy: #MocoUmlRdbCopyTransformationRule ].

	elements do: [ :each |
		| out |
		out := MocoWrappedElement from: (each innerElement deepCopy).
		
		each meta markProcessedBy: #MocoUmlRdbCopyTransformationRule.
		each meta outElements add: out.
		
		engine outModel elements add: out
	].

	elements ifNotEmpty: [
		engine outModel meta didChange: true
	]
]

{ #category : #accessing }
MocoUmlRdbCopyTransformationRule >> priority [
	^ 50
]
