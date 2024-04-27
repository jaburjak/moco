"
Dynamically loads transformation rules and adds them to a transformation engine.
"
Class {
	#name : #MocoTransformationRuleDynamicRepository,
	#superclass : #Object,
	#instVars : [
		'rulesPackage',
		'rulesTag',
		'classPrefix',
		'classSuffix'
	],
	#category : #'Moco-Core-Utils'
}

{ #category : #accessing }
MocoTransformationRuleDynamicRepository >> classPrefix [
	^ classPrefix
]

{ #category : #accessing }
MocoTransformationRuleDynamicRepository >> classPrefix: aString [
	classPrefix := aString
]

{ #category : #accessing }
MocoTransformationRuleDynamicRepository >> classSuffix [
	^ classSuffix
]

{ #category : #accessing }
MocoTransformationRuleDynamicRepository >> classSuffix: aString [
	classSuffix := aString
]

{ #category : #initialization }
MocoTransformationRuleDynamicRepository >> initialize [
	super initialize.
	
	classSuffix := 'TransformationRule'
]

{ #category : #processing }
MocoTransformationRuleDynamicRepository >> injectTo: aMocoTransformationEngine [
	| rules |
	rules := self listRules.
	
	rules := rules collect: [ :each |
		[ each newWithEngine: aMocoTransformationEngine ] on: SubclassResponsibility do: [ nil ]
	].

	rules := rules select: [ :each | each isNotNil ].
	
	aMocoTransformationEngine rules addAll: rules
]

{ #category : #accessing }
MocoTransformationRuleDynamicRepository >> listRules [
	| classes |
	classes := (RPackageOrganizer default packageNamed: rulesPackage) definedClasses.
	
	rulesTag ifNotNil: [
		classes := classes select: [ :each |
			| tag |
			tag := (each category asString) allButFirst: ((rulesPackage size) + 1).
			tag = rulesTag
		]
	].

	classes := classes select: [ :each |
		| className |
		className := each asString.
		((classPrefix isNil) or: [ className beginsWith: classPrefix ]) and: [ (classSuffix isNil) or: [ className endsWith: classSuffix ] ]
	].
	
	^ classes
]

{ #category : #accessing }
MocoTransformationRuleDynamicRepository >> rulesPackage [
	^ rulesPackage
]

{ #category : #accessing }
MocoTransformationRuleDynamicRepository >> rulesPackage: aString [
	rulesPackage := aString
]

{ #category : #accessing }
MocoTransformationRuleDynamicRepository >> rulesTag [
	^ rulesTag
]

{ #category : #accessing }
MocoTransformationRuleDynamicRepository >> rulesTag: aString [
	rulesTag := aString
]
