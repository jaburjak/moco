"
Transforms OntoUML generalization relationships to an Alloy specification.
"
Class {
	#name : #MocoO2AGeneralizationTransformationRule,
	#superclass : #MocoO2ATransformationRule,
	#category : #'Moco-O2A-Rule'
}

{ #category : #transforming }
MocoO2AGeneralizationTransformationRule >> execute [
	| generalizations |
	generalizations := engine input
		selectElementsOfKind: MocoOntoUmlGeneralization
		notGuarded: #MocoO2AGeneralizationTransformationRule.
	
	generalizations do: [ :each |
		self transformGeneralization: each.
		engine input guard: each with: #MocoO2AGeneralizationTransformationRule 
	]
]

{ #category : #'private - processing' }
MocoO2AGeneralizationTransformationRule >> findAlloyNameOf: aMocoOntoUmlClass [
	^ (engine detectOutputElement: aMocoOntoUmlClass ofKind: MocoAlloySignatureField) name
]

{ #category : #'private - accessing' }
MocoO2AGeneralizationTransformationRule >> generalizationFact [
	^ self findFact: 'generalization'
]

{ #category : #accessing }
MocoO2AGeneralizationTransformationRule >> priority [
	^ 70
]

{ #category : #'private - transforming' }
MocoO2AGeneralizationTransformationRule >> transformGeneralization: aMocoOntoUmlGeneralization [
	| fact |
	fact := self generalizationFact.

	self appendFact: fact with: ((self findAlloyNameOf: (aMocoOntoUmlGeneralization subtype)) , ' in ' , (self findAlloyNameOf: (aMocoOntoUmlGeneralization supertype)))
]
