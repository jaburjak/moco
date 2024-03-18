"
Transforms UML generalization sets from Moco’s model to OpenPonk’s model.
"
Class {
	#name : #MocoOpenPonkUmlGeneralizationSetTransformationRule,
	#superclass : #MocoTransformationRule,
	#category : #'Moco-OpenPonk-Rule-Uml'
}

{ #category : #transforming }
MocoOpenPonkUmlGeneralizationSetTransformationRule >> execute [
	| sets |
	sets := engine inModel elements select: [ :each | (each isWrappingType: MocoUmlGeneralizationSet) and: [ each meta isNotProcessedBy: #MocoOpenPonkUmlGeneralizationSetTransformationRule ] ].
	
	sets do: [ :each |
		| set |
		set := self toOpenPonkGeneralizationSet: (each innerElement).
		set := MocoWrappedElement from: set.
		
		each meta outElements add: set.
		engine outModel elements add: set.
		
		each meta markProcessedBy: #MocoOpenPonkUmlGeneralizationSetTransformationRule
	].

	sets ifNotEmpty: [ engine outModel meta didChange: true ]
]

{ #category : #'private - processing' }
MocoOpenPonkUmlGeneralizationSetTransformationRule >> findOutGeneralizationFor: aMocoUmlGeneralization [
	^ ((engine findOutElementsFor: aMocoUmlGeneralization) select: [ :each | each isWrappingType: OPUMLGeneralization ]) first innerElement
]

{ #category : #accessing }
MocoOpenPonkUmlGeneralizationSetTransformationRule >> priority [
	^ 60
]

{ #category : #'private - transforming' }
MocoOpenPonkUmlGeneralizationSetTransformationRule >> toOpenPonkGeneralizationSet: aMocoUmlGeneralizationSet [
	| op |
	op := OPUMLGeneralizationSet new.
	
	op name: (aMocoUmlGeneralizationSet name ifEmpty: [ nil ] ifNotEmpty: [ aMocoUmlGeneralizationSet name ]);
		isDisjoint: (aMocoUmlGeneralizationSet disjoint);
		isCovering: (aMocoUmlGeneralizationSet covering).
	
	aMocoUmlGeneralizationSet members do: [ :each | op generalizations add: (self findOutGeneralizationFor: each) ].
	
	^ op
]
