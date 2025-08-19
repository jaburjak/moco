"
Transforms UML generalization sets from Moco’s model to OpenPonk’s model.
"
Class {
	#name : 'MocoOpenPonkUmlGeneralizationSetTransformationRule',
	#superclass : 'MocoTransformationRule',
	#category : 'Moco-OpenPonk-Rule-Uml',
	#package : 'Moco-OpenPonk',
	#tag : 'Rule-Uml'
}

{ #category : 'transforming' }
MocoOpenPonkUmlGeneralizationSetTransformationRule >> execute [
	| sets |
	sets := engine input
		selectElementsOfKind: MocoUmlGeneralizationSet
		notGuarded: #MocoOpenPonkUmlGeneralizationSetTransformationRule.
	
	sets do: [ :each |
		| set |
		set := self toOpenPonkGeneralizationSet: each.
		
		engine addOutputElement: set withSource: each.
		engine input guard: each with: #MocoOpenPonkUmlGeneralizationSetTransformationRule
	]
]

{ #category : 'private - processing' }
MocoOpenPonkUmlGeneralizationSetTransformationRule >> findOutGeneralizationFor: aMocoUmlGeneralization [
	"Returns the corresponding OpenPonk generalization set for the given Moco element."
	
	^ engine detectOutputElement: aMocoUmlGeneralization ofKind: OPUMLGeneralization
]

{ #category : 'accessing' }
MocoOpenPonkUmlGeneralizationSetTransformationRule >> priority [
	^ 60
]

{ #category : 'private - transforming' }
MocoOpenPonkUmlGeneralizationSetTransformationRule >> toOpenPonkGeneralizationSet: aMocoUmlGeneralizationSet [
	"Creates an OpenPonk generalization set from the given Moco element."
	
	| op |
	op := OPUMLGeneralizationSet new.
	
	op name: (aMocoUmlGeneralizationSet name ifEmpty: [ nil ] ifNotEmpty: [ aMocoUmlGeneralizationSet name ]);
		isDisjoint: (aMocoUmlGeneralizationSet disjoint);
		isCovering: (aMocoUmlGeneralizationSet covering).
	
	aMocoUmlGeneralizationSet members do: [ :each | op generalizations add: (self findOutGeneralizationFor: each) ].
	
	^ op
]
