Class {
	#name : #MocoOntoUmlRoleOptimizationTransformationRuleTest,
	#superclass : #MocoTransformationRuleTestCase,
	#category : #'Moco-O2U-Tests-Rule'
}

{ #category : #'private - processing' }
MocoOntoUmlRoleOptimizationTransformationRuleTest >> execute [
	^ self execute: MocoOntoUmlRoleOptimizationTransformationRule
]

{ #category : #tests }
MocoOntoUmlRoleOptimizationTransformationRuleTest >> testMultipleSupertypes [
	| bearer role generalization mixin generalization2 |
	bearer := { MocoOntoUmlKind new. MocoUmlClass new }.
	engine input addElement: (bearer first).
	engine addOutputElement: (bearer second) withSource: (bearer first).
	
	role := { MocoOntoUmlRole new. MocoUmlClass new }.
	engine input addElement: (role first).
	engine addOutputElement: (role second) withSource: (role first).
	
	generalization := { MocoOntoUmlGeneralization new supertype: (bearer first); subtype: (role first); yourself. MocoUmlAssociation new }.
	generalization second source element: (bearer second).
	generalization second target element: (role second).
	engine input addElement: (generalization first).
	engine addOutputElement: (generalization second) withSource: (generalization first).
	
	mixin := { MocoOntoUmlRoleMixin new. MocoUmlClass new }.
	engine input addElement: (mixin first).
	engine addOutputElement: (mixin second) withSource: (mixin first).
	
	generalization2 := { MocoOntoUmlGeneralization new supertype: (mixin first); subtype: (role first); yourself. MocoUmlGeneralization new supertype: (mixin second); subtype: (role second); yourself }.
	engine input addElement: (generalization2 first).
	engine addOutputElement: (generalization2 second) withSource: (generalization2 first).
	
	engine choiceAnswer: #keep.
	
	self execute.
	
	self assert: (engine choices includes: #optimize) equals: false
]

{ #category : #tests }
MocoOntoUmlRoleOptimizationTransformationRuleTest >> testNonEmpty [
	| bearer role generalization |
	bearer := { MocoOntoUmlKind new. MocoUmlClass new }.
	engine input addElement: (bearer first).
	engine addOutputElement: (bearer second) withSource: (bearer first).
	
	role := { MocoOntoUmlRole new. MocoUmlClass new }.
	role first attributes add: (MocoOntoUmlAttribute new).
	role second attributes add: (MocoUmlAttribute new).
	engine input addElement: (role first).
	engine addOutputElement: (role second) withSource: (role first).
	
	generalization := { MocoOntoUmlGeneralization new supertype: (bearer first); subtype: (role first); yourself. MocoUmlAssociation new }.
	generalization second source element: (bearer second).
	generalization second target element: (role second).
	engine input addElement: (generalization first).
	engine addOutputElement: (generalization second) withSource: (generalization first).
	
	engine choiceAnswer: #keep.
	
	self execute.
	
	self assert: (engine choices includes: #optimize) equals: false
]

{ #category : #tests }
MocoOntoUmlRoleOptimizationTransformationRuleTest >> testOptimization [
	| bearer role generalization relator1 mediation1 |
	bearer := { MocoOntoUmlKind new. MocoUmlClass new }.
	engine input addElement: (bearer first).
	engine addOutputElement: (bearer second) withSource: (bearer first).
	
	role := { MocoOntoUmlRole new. MocoUmlClass new }.
	engine input addElement: (role first).
	engine addOutputElement: (role second) withSource: (role first).
	
	generalization := { MocoOntoUmlGeneralization new supertype: (bearer first); subtype: (role first); yourself. MocoUmlAssociation new }.
	generalization second source element: (bearer second).
	generalization second target element: (role second).
	engine input addElement: (generalization first).
	engine addOutputElement: (generalization second) withSource: (generalization first).
	
	relator1 := { MocoOntoUmlRelator new. MocoUmlClass new }.
	engine input addElement: (relator1 first).
	engine addOutputElement: (relator1 second) withSource: (relator1 first).
	
	mediation1 := { MocoOntoUmlMediationAssociation new. MocoUmlAssociation new }.
	mediation1 first source element: (role first).
	mediation1 first target element: (relator1 first).
	mediation1 second source element: (role second).
	mediation1 second target element: (relator1 second).
	engine input addElement: (mediation1 first).
	engine addOutputElement: (mediation1 second) withSource: (mediation1 first).
	
	engine choiceAnswer: #optimize.
	
	self execute.
	
	self assert: (engine output elements noneSatisfy: [ :each | each == (role second) ]);
		assert: (engine output elements anySatisfy: [ :each | each == (mediation1 second) ]);
		assert: (mediation1 second source element) identicalTo: (bearer second);
		assert: (mediation1 second target multiplicity lower value) equals: 0
]

{ #category : #tests }
MocoOntoUmlRoleOptimizationTransformationRuleTest >> testSupertypeRole [
	| bearer role generalization subtype generalization2 |
	bearer := { MocoOntoUmlKind new. MocoUmlClass new }.
	engine input addElement: (bearer first).
	engine addOutputElement: (bearer second) withSource: (bearer first).
	
	role := { MocoOntoUmlRole new. MocoUmlClass new }.
	engine input addElement: (role first).
	engine addOutputElement: (role second) withSource: (role first).
	
	generalization := { MocoOntoUmlGeneralization new supertype: (bearer first); subtype: (role first); yourself. MocoUmlAssociation new }.
	generalization second source element: (bearer second).
	generalization second target element: (role second).
	engine input addElement: (generalization first).
	engine addOutputElement: (generalization second) withSource: (generalization first).
	
	subtype := { MocoOntoUmlSubKind new. MocoUmlClass new }.
	engine input addElement: (subtype first).
	engine addOutputElement: (subtype second) withSource: (subtype first).
	
	generalization2 := { MocoOntoUmlGeneralization new supertype: (role first); subtype: (subtype first); yourself. MocoUmlGeneralization new supertype: (role second); subtype: (subtype second); yourself }.
	engine input addElement: (generalization2 first).
	engine addOutputElement: (generalization2 second) withSource: (generalization2 first).
	
	engine choiceAnswer: #keep.
	
	self execute.
	
	self assert: (engine choices includes: #optimize) equals: false
]
