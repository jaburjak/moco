Class {
	#name : #MocoOntoUmlRelatorOptimizationTransformationRuleTest,
	#superclass : #MocoTransformationRuleTestCase,
	#category : #'Moco-O2U-Tests-Rule'
}

{ #category : #'private - processing' }
MocoOntoUmlRelatorOptimizationTransformationRuleTest >> execute [
	^ self execute: MocoOntoUmlRelatorOptimizationTransformationRule
]

{ #category : #tests }
MocoOntoUmlRelatorOptimizationTransformationRuleTest >> testGeneralization [
	| class1 class2 mediation1 mediation2 relator mixin generalization |
	class1 := { MocoOntoUmlClass new. MocoUmlClass new }.
	engine input addElement: (class1 first).
	engine addOutputElement: (class1 second) withSource: (class1 first).
	
	class2 := { MocoOntoUmlClass new. MocoUmlClass new }.
	engine input addElement: (class2 first).
	engine addOutputElement: (class2 second) withSource: (class2 first).
	
	relator := { MocoOntoUmlRelator new. MocoUmlClass new }.
	engine input addElement: (relator first).
	engine addOutputElement: (relator second) withSource: (relator first).
	
	mediation1 := { MocoOntoUmlMediationAssociation new. MocoUmlAssociation new }.
	mediation1 first source element: (class1 first).
	mediation1 first target element: (relator first).
	mediation1 second source element: (class1 second).
	mediation1 second target element: (relator second).
	engine input addElement: (mediation1 first).
	engine addOutputElement: (mediation1 second) withSource: (mediation1 first).
	
	mediation2 := { MocoOntoUmlMediationAssociation new. MocoUmlAssociation new }.
	mediation2 first source element: (relator first).
	mediation2 first target element: (class2 first).
	mediation2 second source element: (relator second).
	mediation2 second target element: (class2 second).
	engine input addElement: (mediation2 first).
	engine addOutputElement: (mediation2 second) withSource: (mediation2 first).
	
	mixin := { MocoOntoUmlMixin new. MocoUmlClass new }.
	engine input addElement: (mixin first).
	engine addOutputElement: (mixin second) withSource: (mixin first).
	
	generalization := { MocoOntoUmlGeneralization new supertype: (mixin first); subtype: (relator first); yourself. MocoUmlGeneralization new supertype: (mixin second); subtype: (relator second); yourself }.
	engine input addElement: (generalization first).
	engine addOutputElement: (generalization second) withSource: (generalization first).
	
	engine choiceAnswer: #keep.
	
	self execute.
	
	self assert: (engine choices includes: #optimize) equals: false
]

{ #category : #tests }
MocoOntoUmlRelatorOptimizationTransformationRuleTest >> testNonEmpty [
	| class1 class2 mediation1 mediation2 relator |
	class1 := { MocoOntoUmlClass new. MocoUmlClass new }.
	engine input addElement: (class1 first).
	engine addOutputElement: (class1 second) withSource: (class1 first).
	
	class2 := { MocoOntoUmlClass new. MocoUmlClass new }.
	engine input addElement: (class2 first).
	engine addOutputElement: (class2 second) withSource: (class2 first).
	
	relator := { MocoOntoUmlRelator new. MocoUmlClass new }.
	relator first attributes add: (MocoOntoUmlAttribute new).
	relator second attributes add: (MocoUmlAttribute new).
	engine input addElement: (relator first).
	engine addOutputElement: (relator second) withSource: (relator first).
	
	mediation1 := { MocoOntoUmlMediationAssociation new. MocoUmlAssociation new }.
	mediation1 first source element: (class1 first).
	mediation1 first target element: (relator first).
	mediation1 second source element: (class1 second).
	mediation1 second target element: (relator second).
	engine input addElement: (mediation1 first).
	engine addOutputElement: (mediation1 second) withSource: (mediation1 first).
	
	mediation2 := { MocoOntoUmlMediationAssociation new. MocoUmlAssociation new }.
	mediation2 first source element: (relator first).
	mediation2 first target element: (class2 first).
	mediation2 second source element: (relator second).
	mediation2 second target element: (class2 second).
	engine input addElement: (mediation2 first).
	engine addOutputElement: (mediation2 second) withSource: (mediation2 first).
	
	engine choiceAnswer: #keep.
	
	self execute.
	
	self assert: (engine choices includes: #optimize) equals: false
]

{ #category : #tests }
MocoOntoUmlRelatorOptimizationTransformationRuleTest >> testOneMediation [
	| class1 mediation1 relator |
	class1 := { MocoOntoUmlClass new. MocoUmlClass new }.
	engine input addElement: (class1 first).
	engine addOutputElement: (class1 second) withSource: (class1 first).
	
	relator := { MocoOntoUmlRelator new. MocoUmlClass new }.
	engine input addElement: (relator first).
	engine addOutputElement: (relator second) withSource: (relator first).
	
	mediation1 := { MocoOntoUmlMediationAssociation new. MocoUmlAssociation new }.
	mediation1 first source element: (class1 first).
	mediation1 first target element: (relator first).
	mediation1 second source element: (class1 second).
	mediation1 second target element: (relator second).
	engine input addElement: (mediation1 first).
	engine addOutputElement: (mediation1 second) withSource: (mediation1 first).
	
	engine choiceAnswer: #keep.
	
	self execute.
	
	self assert: (engine choices includes: #optimize) equals: false
]

{ #category : #tests }
MocoOntoUmlRelatorOptimizationTransformationRuleTest >> testOptimization [
	| class1 class2 mediation1 mediation2 relator association |
	class1 := { MocoOntoUmlClass new. MocoUmlClass new }.
	engine input addElement: (class1 first).
	engine addOutputElement: (class1 second) withSource: (class1 first).
	
	class2 := { MocoOntoUmlClass new. MocoUmlClass new }.
	engine input addElement: (class2 first).
	engine addOutputElement: (class2 second) withSource: (class2 first).
	
	relator := { MocoOntoUmlRelator new. MocoUmlClass new }.
	engine input addElement: (relator first).
	engine addOutputElement: (relator second) withSource: (relator first).
	
	mediation1 := { MocoOntoUmlMediationAssociation new. MocoUmlAssociation new }.
	mediation1 first source element: (class1 first).
	mediation1 first source multiplicity lower value: 2.
	mediation1 first source multiplicity upper value: 3.
	mediation1 first target element: (relator first).
	mediation1 first target multiplicity lower value: 4.
	mediation1 first target multiplicity upper value: 5.
	mediation1 second source element: (class1 second).
	mediation1 second source multiplicity lower value: 2.
	mediation1 second source multiplicity upper value: 3.
	mediation1 second target element: (relator second).
	mediation1 second target multiplicity lower value: 4.
	mediation1 second target multiplicity upper value: 5.
	engine input addElement: (mediation1 first).
	engine addOutputElement: (mediation1 second) withSource: (mediation1 first).
	
	mediation2 := { MocoOntoUmlMediationAssociation new. MocoUmlAssociation new }.
	mediation2 first source element: (relator first).
	mediation2 first source multiplicity lower value: 6.
	mediation2 first source multiplicity upper value: 7.
	mediation2 first target element: (class2 first).
	mediation2 first target multiplicity lower value: 8.
	mediation2 first target multiplicity upper value: 9.
	mediation2 second source element: (relator second).
	mediation2 second source multiplicity lower value: 6.
	mediation2 second source multiplicity upper value: 7.
	mediation2 second target element: (class2 second).
	mediation2 second target multiplicity lower value: 8.
	mediation2 second target multiplicity upper value: 9.
	engine input addElement: (mediation2 first).
	engine addOutputElement: (mediation2 second) withSource: (mediation2 first).
	
	engine choiceAnswer: #optimize.
	
	self execute.
	
	self assert: (engine output elements noneSatisfy: [ :each | each == (relator second) ]);
		assert: (engine output elements noneSatisfy: [ :each | each == (mediation1 second) ]);
		assert: (engine output elements noneSatisfy: [ :each | each == (mediation2 second) ]).
	
	association := engine output elements select: [ :each | each isKindOf: MocoUmlAssociation ].
	self assert: (association size) equals: 1.
	association := association first.
	
	self assert: (association source element) identicalTo: (class1 second);
		assert: (association target element) identicalTo: (class2 second);
		assert: (association source multiplicity lower value) equals: (2 * 6);
		assert: (association source multiplicity upper value) equals: (3 * 7);
		assert: (association target multiplicity lower value) equals: (4 * 8);
		assert: (association target multiplicity upper value) equals: (5 * 9)
]

{ #category : #tests }
MocoOntoUmlRelatorOptimizationTransformationRuleTest >> testThreeMediations [
	| class1 class2 class3 mediation1 mediation2 mediation3 relator |
	class1 := { MocoOntoUmlClass new. MocoUmlClass new }.
	engine input addElement: (class1 first).
	engine addOutputElement: (class1 second) withSource: (class1 first).
	
	class2 := { MocoOntoUmlClass new. MocoUmlClass new }.
	engine input addElement: (class2 first).
	engine addOutputElement: (class2 second) withSource: (class2 first).
	
	class3 := { MocoOntoUmlClass new. MocoUmlClass new }.
	engine input addElement: (class3 first).
	engine addOutputElement: (class3 second) withSource: (class3 first).
	
	relator := { MocoOntoUmlRelator new. MocoUmlClass new }.
	engine input addElement: (relator first).
	engine addOutputElement: (relator second) withSource: (relator first).
	
	mediation1 := { MocoOntoUmlMediationAssociation new. MocoUmlAssociation new }.
	mediation1 first source element: (class1 first).
	mediation1 first target element: (relator first).
	mediation1 second source element: (class1 second).
	mediation1 second target element: (relator second).
	engine input addElement: (mediation1 first).
	engine addOutputElement: (mediation1 second) withSource: (mediation1 first).
	
	mediation2 := { MocoOntoUmlMediationAssociation new. MocoUmlAssociation new }.
	mediation2 first source element: (relator first).
	mediation2 first target element: (class2 first).
	mediation2 second source element: (relator second).
	mediation2 second target element: (class2 second).
	engine input addElement: (mediation2 first).
	engine addOutputElement: (mediation2 second) withSource: (mediation2 first).
	
	mediation3 := { MocoOntoUmlMediationAssociation new. MocoUmlAssociation new }.
	mediation3  first source element: (class3 first).
	mediation3 first target element: (relator first).
	mediation3 second source element: (class3 second).
	mediation3 second target element: (relator second).
	engine input addElement: (mediation3 first).
	engine addOutputElement: (mediation3 second) withSource: (mediation3 first).
	
	engine choiceAnswer: #keep.
	
	self execute.
	
	self assert: (engine choices includes: #optimize) equals: false
]
