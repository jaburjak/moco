Class {
	#name : #MocoUmlCopyFixReferencesTransformationRuleTest,
	#superclass : #MocoTransformationRuleTestCase,
	#category : #'Moco-U2D-Tests-Rule-Preprocess'
}

{ #category : #'private - processing' }
MocoUmlCopyFixReferencesTransformationRuleTest >> execute [
	^ self execute: MocoUmlCopyFixReferencesTransformationRule
]

{ #category : #accessing }
MocoUmlCopyFixReferencesTransformationRuleTest >> testAssociations [
	| source target association size |
	source := { MocoUmlClass new. MocoUmlClass new }.
	engine input addElement: (source first).
	engine addOutputElement: (source second) withSource: (source first).
	
	target := { MocoUmlClass new. MocoUmlClass new }.
	engine input addElement: (target first).
	engine addOutputElement: (target second) withSource: (target first).
	
	association := { MocoUmlAssociation new. MocoUmlAssociation new }.
	association first source element: (source first).
	association first target element: (target first).
	association second source element: (source first).
	association second target element: (target first).
	engine input addElement: (association first).
	engine addOutputElement: (association second) withSource: (association first).
	
	size := engine output elements size.
	
	self execute.
	
	self assert: (engine output elements size) equals: size;
		assert: (engine output elements anySatisfy: [ :each | each == (association second) ]);
		assert: (association second source element) identicalTo: (source second);
		assert: (association second target element) identicalTo: (target second)
]

{ #category : #accessing }
MocoUmlCopyFixReferencesTransformationRuleTest >> testExclusiveAssociationConditions [
	| association ocl size |
	association := { MocoUmlAssociation new. MocoUmlAssociation new }.
	engine input addElement: (association first).
	engine addOutputElement: (association second) withSource: (association first).
	
	ocl := { MocoOclExclusiveAssociationCondition new. MocoOclExclusiveAssociationCondition new }.
	ocl first associations add: (OrderedCollection with: (association first)).
	ocl second associations add: (OrderedCollection with: (association first)).
	engine input addElement: (ocl first).
	engine addOutputElement: (ocl second) withSource: (ocl first).
	
	size := engine output elements size.
	
	self execute.
	
	self assert: (engine output elements size) equals: size;
		assert: (engine output elements anySatisfy: [ :each | each == (ocl second) ]);
		assert: (ocl second associations size) equals: 1;
		assert: (ocl second associations first size) equals: 1;
		assert: (ocl second associations first first) identicalTo: (association second)
]

{ #category : #tests }
MocoUmlCopyFixReferencesTransformationRuleTest >> testGeneralizationSets [
	| members set size |
	members := {
		{ MocoUmlGeneralization new supertype: 'A'; subtype: 'B'; yourself. MocoUmlGeneralization new supertype: 'A2'; subtype: 'B2'; yourself }.
		{ MocoUmlGeneralization new supertype: 'C'; subtype: 'D'; yourself. MocoUmlGeneralization new supertype: 'C2'; subtype: 'D2'; yourself }
	}.
	
	set := { MocoUmlGeneralizationSet new. MocoUmlGeneralizationSet new }.
	
	members do: [ :each |
		engine input addElement: (each first).
		engine addOutputElement: (each second) withSource: (each first).
		
		set first members add: (each first).
		set second members add: (each first)
	].
	
	engine input addElement: (set first).
	engine addOutputElement: (set second) withSource: (set first).

	size := engine output elements size.
	
	self execute.
	
	self assert: (engine output elements size) equals: size;
		assert: (engine output elements anySatisfy: [ :each | each == (set second) ]);
		assert: (set second members size) equals: (members size).
	
	members do: [ :each | self assert: (set second members anySatisfy: [ :e | e == (each second) ]) ]
]

{ #category : #tests }
MocoUmlCopyFixReferencesTransformationRuleTest >> testGeneralizations [
	| general specific generalization size |
	general := { 'A'. 'B' }.
	engine input addElement: (general first).
	engine addOutputElement: (general second) withSource: (general first).
	
	specific := { 'C'. 'D' }.
	engine input addElement: (specific first).
	engine addOutputElement: (specific second) withSource: (specific first).
	
	generalization := { MocoUmlGeneralization new supertype: (general first); subtype: (specific first); yourself. MocoUmlGeneralization new supertype: (general first); subtype: (specific first); yourself }.
	engine input addElement: (generalization first).
	engine addOutputElement: (generalization second) withSource: (generalization first).
	
	size := engine output elements size.
	
	self execute.
	
	self assert: (engine output elements size) equals: size;
		assert: (engine output elements anySatisfy: [ :each | each == (generalization second) ] );
		assert: (generalization second supertype) identicalTo: (general second);
		assert: (generalization second subtype) identicalTo: (specific second)
]

{ #category : #accessing }
MocoUmlCopyFixReferencesTransformationRuleTest >> testOcl [
	| context ocl size |
	context := { 'A'. 'B' }.
	engine input addElement: (context first).
	engine addOutputElement: (context second) withSource: (context first).
	
	ocl := { MocoU2DTestInvariant new. MocoU2DTestInvariant new }.
	ocl first context: (context first).
	ocl second context: (context first).
	engine input addElement: (ocl first).
	engine addOutputElement: (ocl second) withSource: (ocl first).
	
	size := engine output elements size.
	
	self execute.
	
	self assert: (engine output elements size) equals: size;
		assert: (engine output elements anySatisfy: [ :each | each == (ocl second) ]);
		assert: (ocl second context) identicalTo: (context second)
]
