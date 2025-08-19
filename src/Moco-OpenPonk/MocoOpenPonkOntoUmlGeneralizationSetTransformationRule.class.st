"
Transforms OpenPonk’s OntoUML generalization sets into their Moco counterparts.
"
Class {
	#name : 'MocoOpenPonkOntoUmlGeneralizationSetTransformationRule',
	#superclass : 'MocoTransformationRule',
	#category : 'Moco-OpenPonk-Rule',
	#package : 'Moco-OpenPonk',
	#tag : 'Rule'
}

{ #category : 'transforming' }
MocoOpenPonkOntoUmlGeneralizationSetTransformationRule >> execute [
	| sets |
	sets := engine input
		selectElementsOfKind: OPUMLGeneralizationSet
		notGuarded: #MocoOpenPonkOntoUmlGeneralizationSetTransformationRule.
	
	sets do: [ :each | self transformGeneralizationSet: each ]
]

{ #category : 'private - processing' }
MocoOpenPonkOntoUmlGeneralizationSetTransformationRule >> findGeneralization: anOPUMLGeneralization [
	"Returns a Moco generalization element corresponding to the given OpenPonk element."
	
	| general specific |
	
	general := engine detectOutputElement: (anOPUMLGeneralization general).
	specific := engine detectOutputElement: (anOPUMLGeneralization specific).
	
	^ (engine output selectElementsOfKind: MocoOntoUmlGeneralization)
			detect: [ :each | ((each supertype) == general) and: [ (each subtype) == specific ] ]
]

{ #category : 'accessing' }
MocoOpenPonkOntoUmlGeneralizationSetTransformationRule >> priority [
	^ 59
]

{ #category : 'private - transforming' }
MocoOpenPonkOntoUmlGeneralizationSetTransformationRule >> transformGeneralizationSet: anOPUMLGeneralizationSet [
	"Transforms an OntoUML generalization set from the OpenPonk model to Moco model."
	
	| set |
	set := MocoOntoUmlGeneralizationSet new.
	
	set name: (anOPUMLGeneralizationSet name);
		covering: (anOPUMLGeneralizationSet isCovering);
		disjoint: (anOPUMLGeneralizationSet isDisjoint).
		
	anOPUMLGeneralizationSet generalizations do: [ :each |
		set members add: (self findGeneralization: each)
	].

	engine addOutputElement: set withSource: anOPUMLGeneralizationSet.
	engine input guard: anOPUMLGeneralizationSet with: #MocoOpenPonkOntoUmlGeneralizationSetTransformationRule
]
