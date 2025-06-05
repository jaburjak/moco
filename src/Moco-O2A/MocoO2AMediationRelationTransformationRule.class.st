"
Transforms the Mediation relationship in an OntoUML model to an Alloy specification.
"
Class {
	#name : 'MocoO2AMediationRelationTransformationRule',
	#superclass : 'MocoO2ARelationTransformationRule',
	#category : 'Moco-O2A-Rule',
	#package : 'Moco-O2A',
	#tag : 'Rule'
}

{ #category : 'transforming' }
MocoO2AMediationRelationTransformationRule >> execute [
	| associations |
	associations := engine input
		selectElementsOfKind: MocoOntoUmlMediationAssociation
		notGuarded: #MocoO2AMediationRelationTransformationRule.

	associations do: [ :each | self generateAcyclicFactFor: each ].

	associations do: [ :each |  engine input guard: each with: #MocoO2AMediationRelationTransformationRule ]
]

{ #category : 'accessing' }
MocoO2AMediationRelationTransformationRule >> priority [
	^ 49
]
