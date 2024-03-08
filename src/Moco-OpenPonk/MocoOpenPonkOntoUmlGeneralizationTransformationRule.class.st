"
Transforms OpenPonk’s OntoUML generalizations into their Moco counterparts.
"
Class {
	#name : #MocoOpenPonkOntoUmlGeneralizationTransformationRule,
	#superclass : #MocoTransformationRule,
	#category : #'Moco-OpenPonk-Rule'
}

{ #category : #transforming }
MocoOpenPonkOntoUmlGeneralizationTransformationRule >> execute [
	| elements |
	elements := engine inModel elements select: [ :e | (e innerElement class canUnderstand: #generalizations) and: [ (e isWrappingType: OPUMLGeneralizationSet) not ] ].
	elements := elements select: [ :e | (e meta isProcessedBy: #MocoOntoUmlGeneralizationTransformationRule) not ].
	
	elements do: [ :el |
		el innerElement generalizations do: [ :each |
			| gen out |
			gen := MocoOntoUmlGeneralization new.
		
			gen supertype: ((engine findOutElementsFor: (each general)) first innerElement);
			subtype: ((engine findOutElementsFor: (each specific)) first innerElement).
			
			out := MocoWrappedElement from: gen.
			
			el meta outElements add: out.
			engine outModel elements add: out.
			engine outModel meta didChange: true.
		].
	
		el meta markProcessedBy: #MocoOntoUmlGeneralizationTransformationRule.
	]
]

{ #category : #accessing }
MocoOpenPonkOntoUmlGeneralizationTransformationRule >> priority [
	^ 60
]
