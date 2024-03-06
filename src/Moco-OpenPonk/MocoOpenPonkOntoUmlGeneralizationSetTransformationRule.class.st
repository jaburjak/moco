"
Transforms OpenPonk’s OntoUML generalization sets into their Moco counterparts.
"
Class {
	#name : #MocoOpenPonkOntoUmlGeneralizationSetTransformationRule,
	#superclass : #MocoTransformationRule,
	#category : #'Moco-OpenPonk-Rule'
}

{ #category : #transforming }
MocoOpenPonkOntoUmlGeneralizationSetTransformationRule >> executeOn: anEngine [
	| sets |
	sets := anEngine inModel elements select: [ :each | (each isWrappingType: OPUMLGeneralizationSet) and: [ (each meta isProcessedBy: #MocoOpenPonkOntoUmlGeneralizationSetTransformationRule) not ] ].
	
	sets do: [ :each |
		| set out |
		set := MocoOntoUmlGeneralizationSet new.
		set name: (each innerElement name);
			covering: (each innerElement isCovering);
			disjoint: (each innerElement isDisjoint).
		
		each innerElement generalizations do: [ :gen |
			set members add: (self findGeneralization: gen in: anEngine)
		].
	
		out := MocoWrappedElement from: set.
			
		each meta markProcessedBy: #MocoOpenPonkOntoUmlGeneralizationSetTransformationRule.
		each meta outElements add: out.
			
		anEngine outModel elements add: out.
		anEngine outModel meta didChange: true.
	]
]

{ #category : #'private - processing' }
MocoOpenPonkOntoUmlGeneralizationSetTransformationRule >> findGeneralization: anOPUMLGeneralization in: anEngine [
	^ ((anEngine outModel elements select: [ :el | el isWrappingType: MocoOntoUmlGeneralization ])
			select: [ :g |
				((g innerElement supertype) == ((anEngine inModel elements select: [ :e | (e innerElement) == (anOPUMLGeneralization general) ]) first meta outElements first innerElement)) and: [
					(g innerElement subtype) == ((anEngine inModel elements select: [ :e | (e innerElement) == (anOPUMLGeneralization specific) ]) first meta outElements first innerElement)
				]
			]) first innerElement
]

{ #category : #accessing }
MocoOpenPonkOntoUmlGeneralizationSetTransformationRule >> priority [
	^ 59
]