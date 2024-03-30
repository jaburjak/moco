"
Updates references to object copies made by MocoUmlRdbCopyTransformationRule.
"
Class {
	#name : #MocoUmlRdbCopyFixReferencesTransformationRule,
	#superclass : #MocoTransformationRule,
	#category : #'Moco-U2D-Rule-Preprocess'
}

{ #category : #transforming }
MocoUmlRdbCopyFixReferencesTransformationRule >> execute [
	"MocoUmlRdbCopyTransformationRule copied elements from the input model to the output model. This rule fixes references
	 in the output elements, as after copying, they still point to elements in the input model, but they must point to the
	 copies in the output model."
	
	self fixGeneralizations;
		fixGeneralizationSets;
		fixAssociations;
		fixOcl
]

{ #category : #'private - transforming' }
MocoUmlRdbCopyFixReferencesTransformationRule >> fixAssociations [
	"Relinks association source and target to the copied elements."
	
	| associations |
	associations := engine output
		selectElementsOfKind: MocoUmlAssociation
		notGuarded: #MocoUmlRdbCopyFixReferencesTransformationRule.
	
	associations do: [ :each |
		| original |
		original := engine detectInputElement: each ofKind: MocoUmlAssociation.
		
		original ifNotNil: [ "ignore associations generated in the current transformation phase"
			| source target |
			
			source := (engine detectOutputElement: (original source element)).
			target := (engine detectOutputElement: (original target element)).
			
			each source element: source.
			each target element: target
		].
		
		engine output guard: each with: #MocoUmlRdbCopyFixReferencesTransformationRule.
		engine output setModified
	]
]

{ #category : #'private - transforming' }
MocoUmlRdbCopyFixReferencesTransformationRule >> fixExclusiveAssociationConditions: aCollection [
	"Relinks associations in exclusive association OCLs to output elements."
	
	| ocls |
	ocls := aCollection select: [ :each | each isKindOf: MocoOclExclusiveAssociationCondition ].
	
	ocls do: [ :each |
		| original associations |
		original := engine detectInputElement: each.
		
		associations := original associations collect: [ :collection |
			collection collect: [ :association | engine detectOutputElement: association ]
		].
		
		each associations removeAll.
		each associations addAll: associations
	]
]

{ #category : #'private - transforming' }
MocoUmlRdbCopyFixReferencesTransformationRule >> fixGeneralizationSets [
	"Relinks members of generalization sets to generalizations in the output model."
	
	| sets |
	sets := engine output
		selectElementsOfKind: MocoUmlGeneralizationSet
		notGuarded: #MocoUmlRdbCopyFixReferencesTransformationRule.
	
	sets do: [ :each |
		| original members |
		original := engine detectInputElement: each.
		
		members := original members collect: [ :member | engine detectOutputElement: member ].
		
		each members removeAll.
		each members addAll: members.
		
		engine output guard: each with: #MocoUmlRdbCopyFixReferencesTransformationRule.
		engine output setModified
	]
]

{ #category : #'private - transforming' }
MocoUmlRdbCopyFixReferencesTransformationRule >> fixGeneralizations [
	"Relinks classes in generalizations to elements in the output model."
	
	| generalizations |
	generalizations := engine output
		selectElementsOfKind: MocoUmlGeneralization
		notGuarded: #MocoUmlRdbCopyFixReferencesTransformationRule.
	
	generalizations do: [ :each |
		| original general specific |
		original := engine detectInputElement: each.
		
		general := engine detectOutputElement: (original supertype).
		specific := engine detectOutputElement: (original subtype).
		
		each supertype: general.
		each subtype: specific.
		
		engine output guard: each with: #MocoUmlRdbCopyFixReferencesTransformationRule.
		engine output setModified
	]
]

{ #category : #'private - transforming' }
MocoUmlRdbCopyFixReferencesTransformationRule >> fixOcl [
	"Relinks the context of OCL constraints to the elements in the output model."
	
	| ocls |
	ocls := engine output
		selectElementsOfKind: MocoOclConstraint
		notGuarded: #MocoUmlRdbCopyFixReferencesTransformationRule.
	
	ocls do: [ :each |
		| original context |
		original := engine detectInputElement: each ofKind: MocoOclConstraint.
		
		original ifNotNil: [ "ignore constraints generated during this transformation phase"
			context := engine detectOutputElement: (original context).
			
			each context: context.
			
			engine output setModified
		].
		
		engine output guard: each with: #MocoUmlRdbCopyFixReferencesTransformationRule
	].

	self fixExclusiveAssociationConditions: ocls
]

{ #category : #accessing }
MocoUmlRdbCopyFixReferencesTransformationRule >> priority [
	^ 49
]
