"
Transforms a UML class generalization from Moco’s model to OpenPonk’s model.
"
Class {
	#name : 'MocoOpenPonkUmlGeneralizationTransformationRule',
	#superclass : 'MocoTransformationRule',
	#category : 'Moco-OpenPonk-Rule-Uml',
	#package : 'Moco-OpenPonk',
	#tag : 'Rule-Uml'
}

{ #category : 'transforming' }
MocoOpenPonkUmlGeneralizationTransformationRule >> execute [
	| generalizations |
	generalizations := engine input
		selectElementsOfKind: MocoUmlGeneralization
		notGuarded: #MocoOpenPonkUmlGeneralizationTransformationRule.
	
	generalizations do: [ :each | self transformGeneralization: each ]
]

{ #category : 'private - processing' }
MocoOpenPonkUmlGeneralizationTransformationRule >> findOutClassFor: aMocoUmlClass [
	"Returns the OpenPonk class that was generated from the given Moco element."
	
	^ engine detectOutputElement: aMocoUmlClass ofKind: OPUMLClass
]

{ #category : 'accessing' }
MocoOpenPonkUmlGeneralizationTransformationRule >> priority [
	^ 65
]

{ #category : 'private - transforming' }
MocoOpenPonkUmlGeneralizationTransformationRule >> toOpenPonkGeneralization: aMocoUmlGeneralization [
	"Creates an OpenPonk generalization element from the the given Moco element."
	
	| op |
	op := OPUMLGeneralization new.
	
	op general: (self findOutClassFor: (aMocoUmlGeneralization supertype));
		specific: (self findOutClassFor: (aMocoUmlGeneralization subtype)).
		
	^ op
]

{ #category : 'private - transforming' }
MocoOpenPonkUmlGeneralizationTransformationRule >> transformGeneralization: aMocoUmlGeneralization [
	"Transforms the given Moco generalization to the OpenPonk model."
	
	| generalization |
	generalization := self toOpenPonkGeneralization: aMocoUmlGeneralization.
	
	engine addOutputElement: generalization withSource: aMocoUmlGeneralization.
	engine input guard: aMocoUmlGeneralization with: #MocoOpenPonkUmlGeneralizationTransformationRule
]
