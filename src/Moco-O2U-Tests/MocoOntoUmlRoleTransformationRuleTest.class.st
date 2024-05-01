Class {
	#name : #MocoOntoUmlRoleTransformationRuleTest,
	#superclass : #MocoOntoUmlClassTransformationRuleTest,
	#category : #'Moco-O2U-Tests-Rule'
}

{ #category : #'private - processing' }
MocoOntoUmlRoleTransformationRuleTest >> execute [
	^ self execute: MocoOntoUmlRoleTransformationRule
]

{ #category : #tests }
MocoOntoUmlRoleTransformationRuleTest >> testMixinGeneralization [
	| role role2 mixin mixin2 generalization generalization2 |
	role := MocoOntoUmlRole new.
	mixin := MocoOntoUmlMixin new.
	generalization := MocoOntoUmlGeneralization new supertype: mixin; subtype: role; yourself.
	
	(engine input) addElement: mixin; addElement: role; addElement: generalization.
	
	role2 := MocoUmlClass new.
	mixin2 := MocoUmlClass new.
	generalization2 := MocoUmlGeneralization new supertype: mixin2; subtype: role2; yourself.
	
	engine addOutputElement: mixin2 withSource: mixin;
		addOutputElement: role2 withSource: role;
		addOutputElement: generalization2 withSource: generalization.
	
	self execute.
	
	self assert: (engine output elements noneSatisfy: [ :each | each isKindOf: MocoUmlAssociation ]);
		assert: (engine output elements anySatisfy: [ :each | each isKindOf: MocoUmlGeneralization ])
]

{ #category : #tests }
MocoOntoUmlRoleTransformationRuleTest >> testRole [
	| ou |
	ou := MocoOntoUmlRole new.
	
	engine input addElement: ou.
	
	self execute.
	
	self assert: (engine output elements first isKindOf: MocoUmlClass)
]

{ #category : #tests }
MocoOntoUmlRoleTransformationRuleTest >> testRoleGeneralization [
	| role role2 kind kind2 generalization generalization2 association |
	role := MocoOntoUmlRole new.
	kind := MocoOntoUmlKind new.
	generalization := MocoOntoUmlGeneralization new supertype: kind; subtype: role; yourself.
	
	(engine input) addElement: kind; addElement: role; addElement: generalization.
	
	role2 := MocoUmlClass new.
	kind2 := MocoUmlClass new.
	generalization2 := MocoUmlGeneralization new supertype: kind2; subtype: role2; yourself.
	
	engine addOutputElement: kind2 withSource: kind;
		addOutputElement: role2 withSource: role;
		addOutputElement: generalization2 withSource: generalization.
	
	self execute.
	
	self assert: ((engine output elements select: [ :each | each isKindOf: MocoUmlGeneralization ]) size) equals: 0.
	
	association := engine output elements select: [ :each | each isKindOf: MocoUmlAssociation ].
	
	self assert: (association size) equals: 1.
	
	association := association first.
	
	self assert: (association source element) identicalTo: kind2;
		assert: (association source multiplicity lower value) equals: 1;
		assert: (association source multiplicity upper value) equals: 1;
		assert: (association source frozen) equals: true;
		assert: (association target element) identicalTo: role2;
		assert: (association target multiplicity lower value) equals: 0;
		assert: (association target multiplicity upper value) equals: 1
]

{ #category : #tests }
MocoOntoUmlRoleTransformationRuleTest >> testRoleMixinGeneralization [
	| role role2 mixin mixin2 generalization generalization2 |
	role := MocoOntoUmlRole new.
	mixin := MocoOntoUmlRoleMixin new.
	generalization := MocoOntoUmlGeneralization new supertype: mixin; subtype: role; yourself.
	
	(engine input) addElement: mixin; addElement: role; addElement: generalization.
	
	role2 := MocoUmlClass new.
	mixin2 := MocoUmlClass new.
	generalization2 := MocoUmlGeneralization new supertype: mixin2; subtype: role2; yourself.
	
	engine addOutputElement: mixin2 withSource: mixin;
		addOutputElement: role2 withSource: role;
		addOutputElement: generalization2 withSource: generalization.
	
	self execute.
	
	self assert: (engine output elements noneSatisfy: [ :each | each isKindOf: MocoUmlAssociation ]);
		assert: (engine output elements anySatisfy: [ :each | each isKindOf: MocoUmlGeneralization ])
]
