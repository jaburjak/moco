"
Transforms OpenPonk’s OntoUML generalizations into their Moco counterparts.
"
Class {
	#name : 'MocoOpenPonkOntoUmlGeneralizationTransformationRule',
	#superclass : 'MocoTransformationRule',
	#category : 'Moco-OpenPonk-Rule',
	#package : 'Moco-OpenPonk',
	#tag : 'Rule'
}

{ #category : 'transforming' }
MocoOpenPonkOntoUmlGeneralizationTransformationRule >> execute [
	| generalizations |
	generalizations := engine input selectElementsNotGuarded: #MocoOntoUmlGeneralizationTransformationRule.
	generalizations := generalizations select: [ :each | (each class canUnderstand: #generalizations) and: [ (each isKindOf: OPUMLGeneralizationSet) not ] ].
	
	generalizations do: [ :each |
		each generalizations do: [ :g |
			| generalization |
			generalization := self toGeneralization: g.
			
			engine addOutputElement: generalization withSource: each
		].
		
		engine input guard: each with: #MocoOntoUmlGeneralizationTransformationRule
	]
]

{ #category : 'accessing' }
MocoOpenPonkOntoUmlGeneralizationTransformationRule >> priority [
	^ 60
]

{ #category : 'private - transforming' }
MocoOpenPonkOntoUmlGeneralizationTransformationRule >> toGeneralization: anOPUMLGeneralization [
	"Returns Moco generalization create from an OpenPonk model."
	
	| generalization general specific |
	generalization := MocoOntoUmlGeneralization new.
	
	general := engine detectOutputElement: (anOPUMLGeneralization general) ofKind: MocoOntoUmlClass.
	specific := engine detectOutputElement: (anOPUMLGeneralization specific) ofKind: MocoOntoUmlClass.
	
	generalization supertype: general;
		subtype: specific.
	
	^ generalization
]
