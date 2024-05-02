"
Provides utility method for asserting the order of transformation rules.
"
Trait {
	#name : #MocoTransformationRulePriorityTestTrait,
	#category : #'Moco-Core-Tests-Trait'
}

{ #category : #asserting }
MocoTransformationRulePriorityTestTrait >> assertRule: aClass isAfter: aCollection [
	"Asserts that the given transformation rule has lower priority than all rules in the given collection."
	
	| testEngine rule |
	testEngine := MocoTestTransformationEngine new.
	
	rule := aClass newWithEngine: testEngine.
	
	aCollection do: [ :each |
		self assert: (((each newWithEngine: testEngine) priority) > (rule priority))
	]
]

{ #category : #asserting }
MocoTransformationRulePriorityTestTrait >> assertRule: aClass isBefore: aCollection [
	"Asserts that the given transformation rule has greater priority than all rules in the given collection."
	
	| testEngine rule |
	testEngine := MocoTestTransformationEngine new.
	
	rule := aClass newWithEngine: testEngine.
	
	aCollection do: [ :each |
		self assert: (((each newWithEngine: testEngine) priority) < (rule priority))
	]
]

{ #category : #asserting }
MocoTransformationRulePriorityTestTrait >> assertRuleOrder: aCollection [
	"Asserts that when sorted by their priority, the rules remain in the same order as given in the collection."
	
	| testEngine expected actual |
	testEngine := MocoTestTransformationEngine new.
	
	expected := aCollection asOrderedCollection.
	
	actual := expected collect: [ :each | { each. ((each newWithEngine: testEngine) priority) } ].
	actual := actual sorted: [ :a :b | (a second) > (b second) ].
	actual := actual collect: [ :each | each first ].
	
	self assert: actual equals: expected
]
