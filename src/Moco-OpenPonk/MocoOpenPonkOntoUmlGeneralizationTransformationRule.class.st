"
Transforms OpenPonk’s OntoUML generalizations into their Moco counterparts.
"
Class {
	#name : #MocoOpenPonkOntoUmlGeneralizationTransformationRule,
	#superclass : #MocoTransformationRule,
	#category : #'Moco-OpenPonk-Rule'
}

{ #category : #accessing }
MocoOpenPonkOntoUmlGeneralizationTransformationRule >> executeOn: anEngine [
	| elements |
	elements := anEngine inModel elements select: [ :e | (e innerElement class canUnderstand: #generalizations) and: [ (e isWrappingType: OPUMLGeneralizationSet) not ] ].
	elements := elements select: [ :e | (e meta isProcessedBy: #MocoOntoUmlGeneralizationTransformationRule) not ].
	
	elements do: [ :el |
		el innerElement generalizations do: [ :each |
			| gen out |
			gen := MocoOntoUmlGeneralization new.
		
			gen supertype: ((anEngine findOutElementsFor: (each general)) first innerElement);
			subtype: ((anEngine findOutElementsFor: (each specific)) first innerElement).
			
			out := MocoWrappedElement from: gen.
			
			el meta outElements add: out.
			anEngine outModel elements add: out.
			anEngine outModel meta didChange: true.
		].
	
		el meta markProcessedBy: #MocoOntoUmlGeneralizationTransformationRule.
	]
]

{ #category : #accessing }
MocoOpenPonkOntoUmlGeneralizationTransformationRule >> priority [
	^ 60
]
