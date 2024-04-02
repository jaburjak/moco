"
Represents an model in the Moco transformation engine.
"
Class {
	#name : #MocoModel,
	#superclass : #Object,
	#instVars : [
		'elements',
		'modified'
	],
	#category : #'Moco-Core-Model'
}

{ #category : #accessing }
MocoModel class >> collectElements: aCollection [
	"Returns a collection of objects wrapped inside MocoWrappedElements."
	
	^ aCollection collect: [ :each | each innerElement ]
]

{ #category : #accessing }
MocoModel >> addElement: anObject [
	"Inserts a new element into the model."
	
	| element |
	element := self wrapElement: anObject.
	
	elements add: element.
	
	self setModified.
	
	^ element
]

{ #category : #accessing }
MocoModel >> addElements: aMocoModel [
	"Adds elements from the given model to the current model. Objects will be passed by reference, element metadata will be discarded."
	
	aMocoModel elements do: [ :each | self addElement: each ]
]

{ #category : #accessing }
MocoModel >> addElements: aMocoModel keepMeta: aCollection [
	"Adds elements from the given model to the current model. Objects will be passed by reference, element metadata not specified in keepMeta: will be discarded."
	
	aMocoModel elements do: [ :each |
		self addElement: each.
		
		aCollection do: [ :key |
			| value |
			value := aMocoModel metaOf: each at: key.
			
			value ifNotNil: [ self metaOf: each at: key put: value ]
		]
	]
]

{ #category : #accessing }
MocoModel >> at: anObject putOutputElement: anObject2 [
	"Adds an output element to the given element."
	
	| output |
	output := anObject2.
	
	(output isKindOf: MocoWrappedElement) ifFalse: [
		output := [ self detectElement: output ] on: Error do: [ self wrapElement: anObject2 ]
	].
	
	(self detectElement: anObject) meta outElements add: output.
	
	self setModified
]

{ #category : #accessing }
MocoModel >> check: anObject isGuarded: aSymbol [
	"Checks whether the given object is guarded by the given symbol."
	
	^ (self detectElement: anObject) meta checkGuard: aSymbol
]

{ #category : #'private - testing' }
MocoModel >> compareElement: anObject to: anObject2 [
	"Checks whether the two elements are the same ones."
	
	^ anObject == anObject2
]

{ #category : #'private - accessing' }
MocoModel >> detectElement: anObject [
	"Returns a MocoWrappedElement stored in this model for the given element."
	
	| element |
	element := elements detect: [ :each | self compareElement: (each innerElement) to: anObject ] ifNone: [ nil ].
	
	element ifNotNil: [ ^ element ].
	
	^ (elements collect: [ :each | each meta outElements detect: [ :e | self compareElement: (e innerElement) to: anObject ] ifNone: [ nil ] ])
		detect: [ :each | each isNotNil ]
		ifNone: [ self error: 'The given element does not exist in the model.' ]
]

{ #category : #accessing }
MocoModel >> elements [
	"Returns all elements in the model."
	
	^ self class collectElements: elements
]

{ #category : #accessing }
MocoModel >> guard: anObject with: aSymbol [
	"Adds a guard symbol to the given element."
	
	(self detectElement: anObject) meta setGuard: aSymbol
]

{ #category : #initialization }
MocoModel >> initialize [
	super initialize.
	
	elements := OrderedCollection new.
	modified := false
]

{ #category : #accessing }
MocoModel >> isModified [
	"Checks whether the modified bit is set."
	
	^ modified
]

{ #category : #accessing }
MocoModel >> metaOf: anObject at: aSymbol [
	"Returns specified metadata of the given object."
	
	^ (self detectElement: anObject) meta at: aSymbol
]

{ #category : #accessing }
MocoModel >> metaOf: anObject at: aSymbol put: anObject2 [
	"Sets the specified metadata on the given object."
	
	(self detectElement: anObject) meta at: aSymbol put: anObject2.
	
	self setModified
]

{ #category : #'private - accessing' }
MocoModel >> purgeElement: aMocoWrappedElement [
	"Removes the given element from all metadata."
	
	elements do: [ :each |
		(each meta outElements anySatisfy: [ :e | e == aMocoWrappedElement ])
			ifTrue: [ self setModified ].
		
		each meta outElements removeAllSuchThat: [ :e | e == aMocoWrappedElement ]
	]
]

{ #category : #'private - accessing' }
MocoModel >> removeElement: anObject [
	"Removes the given element from the model."
	
	| target |
	target := elements select: [ :each | self compareElement: (each innerElement) to: anObject ].
	
	target ifNotEmpty: [ self setModified ].
	
	target do: [ :each | self purgeElement: each ].
	
	elements removeAllSuchThat: [ :each | self compareElement: (each innerElement) to: anObject ].
	
	^ target
]

{ #category : #accessing }
MocoModel >> resetModified [
	"Removes the modified bit."
	
	modified := false
]

{ #category : #'private - accessing' }
MocoModel >> selectElements: anObject [
	"Returns MocoWrappedElements containing the given object."
	
	^ elements select: [ :each | self compareElement: (each innerElement) to: anObject ]
]

{ #category : #accessing }
MocoModel >> selectElementsNotGuarded: aSymbol [
	"Returns all elements that are not guarded by the given symbol."
	
	^ self class collectElements: (elements reject: [ :each | each meta checkGuard: aSymbol ])
]

{ #category : #accessing }
MocoModel >> selectElementsOfKind: aClass [
	"Returns all elements of the given class."
	
	^ self class collectElements: (elements select: [ :each | each isWrappingType: aClass ])
]

{ #category : #accessing }
MocoModel >> selectElementsOfKind: aClass notGuarded: aSymbol [
	"Returns all elements of the given kind that are not guarded by the given symbol."
	
	^ self class collectElements: ((elements select: [ :each | each isWrappingType: aClass ])
												reject: [ :each | each meta checkGuard: aSymbol ])
]

{ #category : #'private - accessing' }
MocoModel >> selectElementsWithOutput: anObject [
	"Returns MocoWrappedElements that contain the given object as their output element."
	
	^ elements select: [ :each | each meta outElements anySatisfy: [ :e | self compareElement: (e innerElement) to: anObject ] ]
]

{ #category : #accessing }
MocoModel >> setModified [
	"Sets the modified bit."
	
	modified := true
]

{ #category : #'private - processing' }
MocoModel >> wrapElement: anObject [
	"Returns anObject wrapped in a MocoWrappedElement, unless it is already wrapped."
	
	(anObject isKindOf: MocoWrappedElement) ifTrue: [ ^ anObject ].
	
	^ MocoWrappedElement from: anObject
]
