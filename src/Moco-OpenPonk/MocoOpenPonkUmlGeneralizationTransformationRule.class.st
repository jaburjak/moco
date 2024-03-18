"
Transforms a UML class generalization from Moco’s model to OpenPonk’s model.
"
Class {
	#name : #MocoOpenPonkUmlGeneralizationTransformationRule,
	#superclass : #MocoTransformationRule,
	#category : #'Moco-OpenPonk-Rule-Uml'
}

{ #category : #transforming }
MocoOpenPonkUmlGeneralizationTransformationRule >> execute [
	| generalizations |
	generalizations := engine inModel elements select: [ :each | (each isWrappingType: MocoUmlGeneralization) and: [ each meta isNotProcessedBy: #MocoOpenPonkUmlGeneralizationTransformationRule ] ].
	
	generalizations do: [ :each |
		| generalization |
		generalization := self toOpenPonkGeneralization: (each innerElement).
		generalization := MocoWrappedElement from: generalization.
		
		each meta outElements add: generalization.
		engine outModel elements add: generalization.
		
		each meta markProcessedBy: #MocoOpenPonkUmlGeneralizationTransformationRule
	].

	generalizations ifNotEmpty: [ engine outModel meta didChange: true ]
]

{ #category : #'private - processing' }
MocoOpenPonkUmlGeneralizationTransformationRule >> findOutClassFor: aMocoUmlClass [
	^ ((engine findOutElementsFor: aMocoUmlClass) select: [ :each | each isWrappingType: OPUMLClass ]) first innerElement
]

{ #category : #accessing }
MocoOpenPonkUmlGeneralizationTransformationRule >> priority [
	^ 65
]

{ #category : #'private - transforming' }
MocoOpenPonkUmlGeneralizationTransformationRule >> toOpenPonkGeneralization: aMocoUmlGeneralization [
	| op |
	op := OPUMLGeneralization new.
	
	op general: (self findOutClassFor: (aMocoUmlGeneralization supertype));
		specific: (self findOutClassFor: (aMocoUmlGeneralization subtype)).
		
	^ op
]
