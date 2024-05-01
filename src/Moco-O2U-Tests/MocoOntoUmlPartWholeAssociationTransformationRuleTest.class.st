Class {
	#name : #MocoOntoUmlPartWholeAssociationTransformationRuleTest,
	#superclass : #MocoOntoUmlAssociationTransformationRuleTest,
	#category : #'Moco-O2U-Tests-Rule'
}

{ #category : #'private - processing' }
MocoOntoUmlPartWholeAssociationTransformationRuleTest >> execute [
	^ self execute: MocoOntoUmlPartWholeAssociationTransformationRule
]

{ #category : #tests }
MocoOntoUmlPartWholeAssociationTransformationRuleTest >> testComponentOf [
	| association association2 |
	association := MocoOntoUmlComponentOfAssociation new.
	association source element: (source first).
	association target element: (target first).
	association source shareability: (MocoOntoUmlAssociationShareability shared).
	
	engine input addElement: association.
	
	self execute.
	
	association2 := engine output elements detect: [ :each | each isKindOf: MocoUmlAssociation ].
	
	self assert: (association2 source frozen) equals: false;
		assert: (association2 target frozen) equals: false
]

{ #category : #tests }
MocoOntoUmlPartWholeAssociationTransformationRuleTest >> testComponentOfEssential [
	| association association2 |
	association := MocoOntoUmlComponentOfAssociation new essential: true; yourself.
	association source element: (source first).
	association target element: (target first).
	association source shareability: (MocoOntoUmlAssociationShareability shared).
	
	engine input addElement: association.
	
	self execute.
	
	association2 := engine output elements detect: [ :each | each isKindOf: MocoUmlAssociation ].
	
	self assert: (association2 source frozen) equals: true;
		assert: (association2 target frozen) equals: false
]

{ #category : #tests }
MocoOntoUmlPartWholeAssociationTransformationRuleTest >> testComponentOfInseparable [
	| association association2 |
	association := MocoOntoUmlComponentOfAssociation new inseparable: true; yourself.
	association source element: (source first).
	association target element: (target first).
	association source shareability: (MocoOntoUmlAssociationShareability shared).
	
	engine input addElement: association.
	
	self execute.
	
	association2 := engine output elements detect: [ :each | each isKindOf: MocoUmlAssociation ].
	
	self assert: (association2 source frozen) equals: false;
		assert: (association2 target frozen) equals: true
]

{ #category : #tests }
MocoOntoUmlPartWholeAssociationTransformationRuleTest >> testMemberOf [
	| association association2 |
	association := MocoOntoUmlMemberOfAssociation new.
	association source element: (source first).
	association target element: (target first).
	association source shareability: (MocoOntoUmlAssociationShareability shared).
	
	engine input addElement: association.
	
	self execute.
	
	association2 := engine output elements detect: [ :each | each isKindOf: MocoUmlAssociation ].
	
	self assert: (association2 source frozen) equals: false;
		assert: (association2 target frozen) equals: false
]

{ #category : #tests }
MocoOntoUmlPartWholeAssociationTransformationRuleTest >> testMemberOfEssential [
	| association association2 |
	association := MocoOntoUmlMemberOfAssociation new essential: true; yourself.
	association source element: (source first).
	association target element: (target first).
	association source shareability: (MocoOntoUmlAssociationShareability shared).
	
	engine input addElement: association.
	
	self execute.
	
	association2 := engine output elements detect: [ :each | each isKindOf: MocoUmlAssociation ].
	
	self assert: (association2 source frozen) equals: true;
		assert: (association2 target frozen) equals: false
]

{ #category : #tests }
MocoOntoUmlPartWholeAssociationTransformationRuleTest >> testMemberOfInseparable [
	| association association2 |
	association := MocoOntoUmlMemberOfAssociation new inseparable: true; yourself.
	association source element: (source first).
	association target element: (target first).
	association source shareability: (MocoOntoUmlAssociationShareability shared).
	
	engine input addElement: association.
	
	self execute.
	
	association2 := engine output elements detect: [ :each | each isKindOf: MocoUmlAssociation ].
	
	self assert: (association2 source frozen) equals: false;
		assert: (association2 target frozen) equals: true
]

{ #category : #tests }
MocoOntoUmlPartWholeAssociationTransformationRuleTest >> testSubCollectionOf [
	| association association2 |
	association := MocoOntoUmlSubCollectionOfAssociation new.
	association source element: (source first).
	association target element: (target first).
	association source shareability: (MocoOntoUmlAssociationShareability shared).
	
	engine input addElement: association.
	
	self execute.
	
	association2 := engine output elements detect: [ :each | each isKindOf: MocoUmlAssociation ].
	
	self assert: (association2 source frozen) equals: false;
		assert: (association2 target frozen) equals: false
]

{ #category : #tests }
MocoOntoUmlPartWholeAssociationTransformationRuleTest >> testSubCollectionOfEssential [
	| association association2 |
	association := MocoOntoUmlSubCollectionOfAssociation new essential: true; yourself.
	association source element: (source first).
	association target element: (target first).
	association source shareability: (MocoOntoUmlAssociationShareability shared).
	
	engine input addElement: association.
	
	self execute.
	
	association2 := engine output elements detect: [ :each | each isKindOf: MocoUmlAssociation ].
	
	self assert: (association2 source frozen) equals: true;
		assert: (association2 target frozen) equals: false
]

{ #category : #tests }
MocoOntoUmlPartWholeAssociationTransformationRuleTest >> testSubCollectionOfInseparable [
	| association association2 |
	association := MocoOntoUmlSubCollectionOfAssociation new inseparable: true; yourself.
	association source element: (source first).
	association target element: (target first).
	association source shareability: (MocoOntoUmlAssociationShareability shared).
	
	engine input addElement: association.
	
	self execute.
	
	association2 := engine output elements detect: [ :each | each isKindOf: MocoUmlAssociation ].
	
	self assert: (association2 source frozen) equals: false;
		assert: (association2 target frozen) equals: true
]

{ #category : #tests }
MocoOntoUmlPartWholeAssociationTransformationRuleTest >> testSubQuantityOf [
	| association association2 |
	association := MocoOntoUmlSubQuantityOfAssociation new.
	association source element: (source first).
	association target element: (target first).
	association source shareability: (MocoOntoUmlAssociationShareability shared).
	
	engine input addElement: association.
	
	self execute.
	
	association2 := engine output elements detect: [ :each | each isKindOf: MocoUmlAssociation ].
	
	self assert: (association2 source frozen) equals: false;
		assert: (association2 target frozen) equals: false
]

{ #category : #tests }
MocoOntoUmlPartWholeAssociationTransformationRuleTest >> testSubQuantityOfEssential [
	| association association2 |
	association := MocoOntoUmlSubQuantityOfAssociation new essential: true; yourself.
	association source element: (source first).
	association target element: (target first).
	association source shareability: (MocoOntoUmlAssociationShareability shared).
	
	engine input addElement: association.
	
	self execute.
	
	association2 := engine output elements detect: [ :each | each isKindOf: MocoUmlAssociation ].
	
	self assert: (association2 source frozen) equals: true;
		assert: (association2 target frozen) equals: false
]

{ #category : #tests }
MocoOntoUmlPartWholeAssociationTransformationRuleTest >> testSubQuantityOfInseparable [
	| association association2 |
	association := MocoOntoUmlSubQuantityOfAssociation new inseparable: true; yourself.
	association source element: (source first).
	association target element: (target first).
	association source shareability: (MocoOntoUmlAssociationShareability shared).
	
	engine input addElement: association.
	
	self execute.
	
	association2 := engine output elements detect: [ :each | each isKindOf: MocoUmlAssociation ].
	
	self assert: (association2 source frozen) equals: false;
		assert: (association2 target frozen) equals: true
]
