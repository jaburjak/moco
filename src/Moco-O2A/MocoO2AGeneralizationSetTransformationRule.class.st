"
Transforms OntoUML generalization sets to an Alloy specification.
"
Class {
	#name : 'MocoO2AGeneralizationSetTransformationRule',
	#superclass : 'MocoO2ATransformationRule',
	#category : 'Moco-O2A-Rule',
	#package : 'Moco-O2A',
	#tag : 'Rule'
}

{ #category : 'transforming' }
MocoO2AGeneralizationSetTransformationRule >> execute [
	| sets |
	sets := engine input
		selectElementsOfKind: MocoOntoUmlGeneralizationSet
		notGuarded: #MocoO2AGeneralizationSetTransformationRule.
	
	sets do: [ :each |
		self transformGeneralizationSet: each.
		engine input guard: each with: #MocoO2AGeneralizationSetTransformationRule 
	]
]

{ #category : 'private - processing' }
MocoO2AGeneralizationSetTransformationRule >> findAlloyNameOf: aMocoOntoUmlClass [
	^ (engine detectOutputElement: aMocoOntoUmlClass ofKind: MocoAlloySignatureField) name
]

{ #category : 'private - accessing' }
MocoO2AGeneralizationSetTransformationRule >> generalizationSetFact [
	^ self findFact: 'generalizationSet'
]

{ #category : 'accessing' }
MocoO2AGeneralizationSetTransformationRule >> priority [
	^ 69
]

{ #category : 'private - transforming' }
MocoO2AGeneralizationSetTransformationRule >> transformGeneralizationSet: aMocoOntoUmlGeneralizationSet [
	| subclasses |
	subclasses := aMocoOntoUmlGeneralizationSet members collect: [ :e | self findAlloyNameOf: (e subtype) ].

	(aMocoOntoUmlGeneralizationSet disjoint) ifTrue: [
		((subclasses size) > 1) ifTrue: [
			self appendFact: (self generalizationSetFact) with: ('disj[' , (', ' join: subclasses) , ']')
		]
	].

	(aMocoOntoUmlGeneralizationSet covering) ifTrue: [
		self appendFact: (self generalizationSetFact) with: ((self findAlloyNameOf: (aMocoOntoUmlGeneralizationSet members first supertype)) , ' = ' , ('+' join: subclasses))
	]
]
