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

{ #category : #'private - transforming' }
MocoTransformationEngine >> applyRule: aRule [
	"Executes the given transformation rule repeatedly until the output model no longer changes."

	[
		| prev curr |
		prev := outModel meta didChange.
		outModel meta didChange: false.
		
		self updateProgress: aRule.
		
		aRule execute.
		
		curr := outModel meta didChange.
		
		curr ifTrue: [ self incrementJobMax: 1 ].
		
		outModel meta didChange: (prev or: curr).
		
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
MocoTransformationEngine >> findInElementFor: aMocoWrappedElement [
	^ inModel elements detect: [ :each | each meta outElements anySatisfy: [ :e | e == aMocoWrappedElement ] ] ifNone: [ nil ]
]

{ #category : #'as yet unclassified' }
MocoTransformationEngine >> findOutElementsFor: anElement [
	^ ((inModel elements select: [ :each | each innerElement == anElement ]) flatCollect: [ :each | each meta outElements ]).
]

{ #category : #accessing }
MocoTransformationEngine >> inModel [
	^ inModel
]

{ #category : #accessing }
MocoTransformationEngine >> inModel: aWrappedModel [
	inModel := aWrappedModel
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
	
	rules := SortedCollection sortBlock: [ :a :b | (a priority) > (b priority) ]
]

{ #category : #accessing }
MocoTransformationEngine >> outModel [
	^ outModel
]

{ #category : #accessing }
MocoTransformationEngine >> outModel: aWrappedModel [
	outModel := aWrappedModel
]

{ #category : #accessing }
MocoTransformationEngine >> rules [
	^ rules
]

{ #category : #accessing }
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
			outModel meta didChange: false.
			
			self applyRules.
			
			outModel meta didChange ifTrue: [ self incrementJobMax: (rules size) ].
			
			outModel meta didChange
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
