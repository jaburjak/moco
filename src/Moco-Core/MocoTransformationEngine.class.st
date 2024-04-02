"
Transforms one model to another according to specified rules.
"
Class {
	#name : #MocoTransformationEngine,
	#superclass : #Object,
	#instVars : [
		'rules',
		'inModel',
		'outModel',
		'job'
	],
	#category : #'Moco-Core-Engine'
}

{ #category : #accessing }
MocoTransformationEngine >> addOutputElement: anObject [
	"Adds a new element to the output model."
	
	outModel addElement: anObject
]

{ #category : #accessing }
MocoTransformationEngine >> addOutputElement: anObject withSource: anObject2 [
	"Adds a new element to the output model and links it to the input element in withSource:."
	
	| output |
	
	output := outModel addElement: anObject.
	
	inModel at: anObject2 putOutputElement: output
]

{ #category : #'private - transforming' }
MocoTransformationEngine >> applyRule: aRule [
	"Executes the given transformation rule repeatedly until the output model no longer changes."

	[
		| prev curr |
		prev := outModel isModified.
		outModel resetModified.
		
		self updateProgress: aRule.
		
		aRule execute.
		
		curr := outModel isModified.
		
		curr ifTrue: [ self incrementJobMax: 1 ].
		
		(prev or: curr) ifTrue: [ outModel setModified ].
		
		curr
	] whileTrue.
]

{ #category : #'private - transforming' }
MocoTransformationEngine >> applyRules [
	"Applies transformation rules."

	rules do: [ :rule | self applyRule: rule ]
]

{ #category : #accessing }
MocoTransformationEngine >> askChoice: aMocoChoiceBuilder [
	| dialog |
	dialog := (self spApplication) new: MocoChoicePresenter.
	
	dialog question: (aMocoChoiceBuilder question).
	
	aMocoChoiceBuilder choices do: [ :each |
		dialog addChoice: (each label) withId: (each id)
	].

	dialog openAndWait.
	
	dialog choice ifNil: [
		^ aMocoChoiceBuilder choices first id
	] ifNotNil: [
		^ dialog choice
	]
]

{ #category : #accessing }
MocoTransformationEngine >> atInput: anObject putOutputElement: anObject2 [
	"Adds an output element to the given input element."
	
	inModel at: anObject putOutputElement: ([ outModel detectElement: anObject2 ] on: Error do: [ nil ])
]

{ #category : #accessing }
MocoTransformationEngine >> detectInputElement: anObject [
	"Returns the first input element of the given object."
	
	| elements |
	elements := self selectInputElements: anObject.
	
	elements ifEmpty: [ ^ nil ].
	
	^ elements first
]

{ #category : #accessing }
MocoTransformationEngine >> detectInputElement: anObject ofKind: aClass [
	"Returns the first input element of the given object that is of the given kind."
	
	| elements |
	elements := self selectInputElements: anObject ofKind: aClass.
	
	elements ifEmpty: [ ^ nil ].
	
	^ elements first
]

{ #category : #accessing }
MocoTransformationEngine >> detectInputElement: anObject ofKind: aClass notGuarded: aSymbol [
	"Returns the first input element of the given object that is of the given kind and is not guarded by the given symbol."
	
	| elements |
	elements := self selectInputElements: anObject ofKind: aClass notGuarded: aSymbol.
	
	elements ifEmpty: [ ^ nil ].
	
	^ elements first
]

{ #category : #accessing }
MocoTransformationEngine >> detectOutputElement: anObject [
	"Returns the first output element of the given object."
	
	| elements |
	elements := self selectOutputElements: anObject.
	
	elements ifEmpty: [ ^ nil ].
	
	^ elements first
]

{ #category : #accessing }
MocoTransformationEngine >> detectOutputElement: anObject ofKind: aClass [
	"Returns the first output element of the given object that is of the given kind."
	
	| elements |
	elements := self selectOutputElements: anObject ofKind: aClass.
	
	elements ifEmpty: [ ^ nil ].
	
	^ elements first
]

{ #category : #accessing }
MocoTransformationEngine >> detectOutputElement: anObject ofKind: aClass notGuarded: aSymbol [
	"Returns the first output element of the given object that is of the given kind and is not guarded by the given symbol."
	
	| elements |
	elements := self selectOutputElements: anObject ofKind: aClass notGuarded: aSymbol.
	
	elements ifEmpty: [ ^ nil ].
	
	^ elements first
]

{ #category : #'private - accessing' }
MocoTransformationEngine >> inModel: aMocoModel [
	inModel := aMocoModel
]

{ #category : #'private - processing' }
MocoTransformationEngine >> incrementJobMax: aNumber [
	job ifNotNil: [
		| val |
		val := job currentValue.
		job max: ((job max) + aNumber);
			currentValue: val
	]
]

{ #category : #initialization }
MocoTransformationEngine >> initialize [
	super initialize.
	
	rules := SortedCollection sortBlock: [ :a :b | (a priority) > (b priority) ].
	inModel := MocoModel new.
	outModel := MocoModel new
]

{ #category : #accessing }
MocoTransformationEngine >> input [
	"Returns the input model."
	
	^ inModel
]

{ #category : #'private - accessing' }
MocoTransformationEngine >> outModel: aMocoModel [
	outModel := aMocoModel
]

{ #category : #accessing }
MocoTransformationEngine >> output [
	"Returns the output model."
	
	^ outModel
]

{ #category : #accessing }
MocoTransformationEngine >> removeOutputElement: anObject [
	"Removes the given element from the output model."
	
	| removed |
	removed := outModel removeElement: anObject.
	
	removed do: [ :each | inModel purgeElement: each ]
]

{ #category : #'private - accessing' }
MocoTransformationEngine >> rules [
	^ rules
]

{ #category : #accessing }
MocoTransformationEngine >> selectInputElements: anObject [
	"Returns source elements of the given object."
	
	^ MocoModel collectElements: (inModel selectElementsWithOutput: anObject)
]

{ #category : #accessing }
MocoTransformationEngine >> selectInputElements: anObject ofKind: aClass [
	"Returns source elements of the given object that are of the given kind."
	
	^ MocoModel collectElements: ((inModel selectElementsWithOutput: anObject) select: [ :each | each isWrappingType: aClass ])
]

{ #category : #accessing }
MocoTransformationEngine >> selectInputElements: anObject ofKind: aClass notGuarded: aSymbol [
	"Returns source elements of the given object that are of the given kind and are not guarded by the given symbol."
	
	^ MocoModel collectElements: ((inModel selectElementsWithOutput: anObject)
		select: [ :each | (each isWrappingType: aClass) and: [ each meta checkNotGuard: aSymbol ] ])
]

{ #category : #accessing }
MocoTransformationEngine >> selectOutputElements: anObject [
	"Returns all elements that have been created with anObject as their source."
	
	^ MocoModel collectElements: ((inModel selectElements: anObject) flatCollect: [ :each | each meta outElements ])
]

{ #category : #accessing }
MocoTransformationEngine >> selectOutputElements: anObject ofKind: aClass [
	"Returns output elements of the given object that are of the given kind."
	
	^ MocoModel collectElements: (((inModel selectElements: anObject) flatCollect: [ :each | each meta outElements ])
		select: [ :each | each isWrappingType: aClass ])
]

{ #category : #accessing }
MocoTransformationEngine >> selectOutputElements: anObject ofKind: aClass notGuarded: aSymbol [
	"Returns output elements of the given object that are of the given kind and are not guarded by the given symbol."
	
	^ MocoModel collectElements: (((inModel selectElements: anObject) flatCollect: [ :each | each meta outElements ])
		select: [ :each | (each isWrappingType: aClass) and: [ each checkNotGuard: aSymbol ] ])
]

{ #category : #'private - accessing' }
MocoTransformationEngine >> spApplication [
	^ MocoSpApplication instance
]

{ #category : #transforming }
MocoTransformationEngine >> transform [
	"Transforms the model using transformation rules."
	
	[ :j |
		job := j.
		job title: 'Transformation in progress...';
			max: rules size.
		
		[
			outModel resetModified.
			
			self applyRules.
			
			outModel isModified ifTrue: [ self incrementJobMax: (rules size) ].
			
			outModel isModified
		] whileTrue
	] asJob run
]

{ #category : #'private - processing' }
MocoTransformationEngine >> updateProgress: aMocoTransformationRule [
	job ifNotNil: [
		job
			increment;
			title: 'Transforming:' , (Character cr asString) , (aMocoTransformationRule class asString).
	]
]
