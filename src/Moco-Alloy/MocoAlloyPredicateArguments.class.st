"
Represents predicate or function arguments in an Alloy specification.
"
Class {
	#name : #MocoAlloyPredicateArguments,
	#superclass : #Object,
	#instVars : [
		'names',
		'types'
	],
	#category : #'Moco-Alloy-Model'
}

{ #category : #adding }
MocoAlloyPredicateArguments >> add: aString ofType: aString2 [
	names add: aString.
	types add: aString2
]

{ #category : #converting }
MocoAlloyPredicateArguments >> asList [
	^ names with: types collect: [ :n :t | {n. t} ]
]

{ #category : #initialization }
MocoAlloyPredicateArguments >> initialize [
	super initialize.

	names := OrderedCollection new.
	types := OrderedCollection new
]

{ #category : #printing }
MocoAlloyPredicateArguments >> printTo: aStream [
	| args |
	args := (self asList) collect: [ :e | (e first) , ': ' , (e second) ].

	args ifNotEmpty: [
		aStream nextPutAll: (', ' join: args)
	]
]

{ #category : #removing }
MocoAlloyPredicateArguments >> remove: aString [
	| idxs |
	idxs := names withIndexCollect: [ :e :i | (e = aString) ifTrue: [ i ] ifFalse: [ nil ] ].
	idxs := idxs reject: [ :e | e isNil ].

	idxs ifNotEmpty: [
		| i |
		i := idxs first.

		names removeAt: i.
		types removeAt: i.
		
		self remove: aString
	]
]

{ #category : #removing }
MocoAlloyPredicateArguments >> removeAll [
	names := OrderedCollection new.
	types := OrderedCollection new
]
