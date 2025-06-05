"
Transforms the Material relationship in an OntoUML model to an Alloy specification.
"
Class {
	#name : 'MocoO2AMaterialRelationTransformationRule',
	#superclass : 'MocoO2ARelationTransformationRule',
	#category : 'Moco-O2A-Rule',
	#package : 'Moco-O2A',
	#tag : 'Rule'
}

{ #category : 'transforming' }
MocoO2AMaterialRelationTransformationRule >> execute [
	| associations |
	associations := engine input
		selectElementsOfKind: MocoOntoUmlMaterialAssociation
		notGuarded: #MocoO2ARelationTransformationRule.
	
	associations do: [ :each | self transformRelation: each ].

	associations do: [ :each |  engine input guard: each with: #MocoO2ARelationTransformationRule ]
]

{ #category : 'private - processing' }
MocoO2AMaterialRelationTransformationRule >> findRelatorFor: aMocoOntoUmlAssociation [
	| mediations relators |

	(aMocoOntoUmlAssociation isKindOf: MocoOntoUmlMaterialAssociation) ifFalse: [ ^ nil ].

	mediations := engine input elements select: [ :e | (e isKindOf: MocoOntoUmlMediationAssociation) and: [
		(((e source element) == (aMocoOntoUmlAssociation source element)) and: [ e target element isKindOf: MocoOntoUmlRelator ]) or: [
			((e target element) == (aMocoOntoUmlAssociation source element)) and: [ e source element isKindOf: MocoOntoUmlRelator ]
		]
	] ].

	mediations addAll: (engine input elements select: [ :e | (e isKindOf: MocoOntoUmlMediationAssociation) and: [
		(((e source element) == (aMocoOntoUmlAssociation target element)) and: [ e target element isKindOf: MocoOntoUmlRelator ]) or: [
			((e target element) == (aMocoOntoUmlAssociation target element)) and: [ e source element isKindOf: MocoOntoUmlRelator ]
		]
	] ]).

	relators := OrderedCollection new.

	mediations do: [ :e |
		| r |
		((((e source element) == (aMocoOntoUmlAssociation source element)) not) and: [ ((e source element) == (aMocoOntoUmlAssociation target element)) not ])
			ifTrue: [ r := e source element ]
			ifFalse: [ r := e target element ].

		(relators noneSatisfy: [ :c | c == r ]) ifTrue: [ relators add: r ]
	].

	((relators size) = 1) ifTrue: [ ^ relators first ].

	^ nil
]

{ #category : 'accessing' }
MocoO2AMaterialRelationTransformationRule >> priority [
	^ 51
]

{ #category : 'private - transforming' }
MocoO2AMaterialRelationTransformationRule >> transformRelation: aMocoOntoUmlAssociation [
	| relator sig field |
	relator := self findRelatorFor: aMocoOntoUmlAssociation.

	relator ifNil: [ ^ super transformRelation: aMocoOntoUmlAssociation ].

	sig := ((self findClassFieldFor: (aMocoOntoUmlAssociation source element)) name).
	sig := sig , ' -> ' , ((self findClassFieldFor: relator) name) , ' -> '.
	sig := sig , ((self findClassFieldFor: (aMocoOntoUmlAssociation target element)) name).

	field := MocoAlloySignatureField new
		name: (self toLowerAlloyName: (aMocoOntoUmlAssociation name) ifEmpty: 'relation');
		multiplicity: #set;
		signature: sig;
		yourself.

	(self worldSig) fields add: field.

	engine atInput: aMocoOntoUmlAssociation putOutputElement: field.

	self generateSourceEndFnFor: aMocoOntoUmlAssociation withField: field;
		generateTargetEndFnFor: aMocoOntoUmlAssociation withField: field;
		generateOrderingFactFor: aMocoOntoUmlAssociation withField: field;
		generateMultiplicityFactOf: aMocoOntoUmlAssociation;
		generateImmutabilityFactOf: aMocoOntoUmlAssociation.

	engine output setModified
]
