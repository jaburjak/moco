"
Transforms OntoUML generalizations into UML generalizations.
"
Class {
	#name : #MocoOntoUmlGeneralizationTransformationRule,
	#superclass : #MocoTransformationRule,
	#category : #'Moco-O2U-Rule'
}

{ #category : #transforming }
MocoOntoUmlGeneralizationTransformationRule >> execute [
	| generalizations |
	generalizations := engine input
		selectElementsOfKind: MocoOntoUmlGeneralization
		notGuarded: #MocoOntoUmlGeneralizationTransformationRule.
	
	generalizations := generalizations reject: [ :each | (engine detectOutputElement: each) isNotNil ]. "generalization may have already been processed by another rule"
	
	generalizations := generalizations reject: [ :each | ((engine detectOutputElement: (each supertype)) isNil) or: [ (engine detectOutputElement: (each subtype)) isNil ] ].
	
	generalizations do: [ :each |
		engine addOutputElement: (self toUmlGeneralization: each) withSource: each.
		engine input guard: each with: #MocoOntoUmlGeneralizationTransformationRule
	]
]

{ #category : #accessing }
MocoOntoUmlGeneralizationTransformationRule >> priority [
	^ 50
]

{ #category : #'private - transforming' }
MocoOntoUmlGeneralizationTransformationRule >> toUmlGeneralization: aMocoOntoUmlGeneralization [
	"Returns a UML generalization create from the given OntoUML generalization."
	
	| uml |
	uml := MocoUmlGeneralization new.
	
	uml supertype: (engine detectOutputElement: (aMocoOntoUmlGeneralization supertype));
		subtype: (engine detectOutputElement: (aMocoOntoUmlGeneralization subtype)).
	
	^ uml
]
