"
Abstract base for OntoUML to Alloy transformation rules.
"
Class {
	#name : 'MocoO2ATransformationRule',
	#superclass : 'MocoTransformationRule',
	#category : 'Moco-O2A-Rule',
	#package : 'Moco-O2A',
	#tag : 'Rule'
}

{ #category : 'instance creation' }
MocoO2ATransformationRule class >> new [
	(self asString = 'MocoO2ATransformationRule')
		ifTrue: [ ^ self subclassResponsibility ]
		ifFalse: [ ^ super new ]
]

{ #category : 'instance creation' }
MocoO2ATransformationRule class >> newWithEngine: anEngine [
	(self asString = 'MocoO2ATransformationRule')
		ifTrue: [ ^ self subclassResponsibility ]
		ifFalse: [ ^ super newWithEngine: anEngine ]
]

{ #category : 'private - processing' }
MocoO2ATransformationRule >> appendFact: aMocoAlloyFact with: aString [
	(aMocoAlloyFact body) ifNotEmpty: [
		aMocoAlloyFact body: ((aMocoAlloyFact body) , (String cr))
	].

	aMocoAlloyFact body: ((aMocoAlloyFact body) , aString).

	engine output setModified
]

{ #category : 'private - accessing' }
MocoO2ATransformationRule >> findFact: aString [
	"Returns or creates an Alloy fact with the given name."

	^ engine output elements
		detect: [ :e | (e isKindOf: MocoAlloyFact) and: [ e name = aString ] ]
		ifNone: [
			| fact |
			fact := MocoAlloyFact new.
			fact name: aString.

			engine addOutputElement: fact.

			^ fact
		]
]

{ #category : 'private - processing' }
MocoO2ATransformationRule >> toAlloyName: aString [
	^ self toAlloyName: aString withConverter: [ :n | MocoNamingUtils toPascalCase: n ] ifEmpty: [ nil ]
]

{ #category : 'private - processing' }
MocoO2ATransformationRule >> toAlloyName: aString ifEmpty: aString2 [
	(aString isEmptyOrNil) ifTrue: [ ^ self toAlloyName: aString2 ].

	^ self toAlloyName: aString
]

{ #category : 'private - processing' }
MocoO2ATransformationRule >> toAlloyName: aString withConverter: aBlock ifEmpty: aString2 [
	| name |
	name := aString.

	(name isEmptyOrNil) ifTrue: [ ^ aString2 ].
	(name isEmptyOrNil) ifTrue: [ ^ nil ].

	name := aBlock value: name.

	^ MocoUniqueNameGenerator at: [ :n |
		(engine output elements anySatisfy: [ :e | (e respondsTo: #name) and: [ (e name) = n ] ]) or: [
			engine output elements anySatisfy: [ :e | (e isKindOf: MocoAlloySignature) and: [
				e fields anySatisfy: [ :f | (f name) = n ]
			] ]
		]
	] seed: name
]

{ #category : 'private - processing' }
MocoO2ATransformationRule >> toLowerAlloyName: aString [
	^ self toAlloyName: aString withConverter: [ :n |
		| parts |
		parts := '_' split: n.

		(parts size > 1)
			ifTrue: [
				parts := parts withIndexCollect: [ :p :i |
					(i = 1) ifTrue: [ (MocoNamingUtils toPascalCase: p) , '_' ]
						ifFalse: [
							((i = (parts size)) and: [ (p endsWith: 'Fn') or: [ p endsWith: 'End' ] ])
								ifTrue: [ '_' , (MocoNamingUtils toCamelCase: p) ]
								ifFalse: [
									(i = 2) ifTrue: [ MocoNamingUtils toCamelCase: p ]
										ifFalse: [ MocoNamingUtils toPascalCase: p ]
								]
						]
				].
			
				('' join: parts) copyReplaceAll: '__' with: '_'
			] ifFalse: [
				MocoNamingUtils toCamelCase: n
			]
	] ifEmpty: [ nil ]
]

{ #category : 'private - processing' }
MocoO2ATransformationRule >> toLowerAlloyName: aString ifEmpty: aString2 [
	(aString isEmptyOrNil) ifTrue: [ ^ self toLowerAlloyName: aString2 ].

	^ self toLowerAlloyName: aString
]

{ #category : 'private - accessing' }
MocoO2ATransformationRule >> worldSig [
	"Returns the World main signature."

	| world |

	engine output elements do: [ :e |
		((e isKindOf: MocoAlloySignature) and: [ e name = 'World' ])
			ifTrue: [ ^ e ]
	].

	world := MocoAlloySignature new
		name: 'World';
		abstract: true.
	
	world fields add: (MocoAlloySignatureField new name: 'exists'; multiplicity: #some; signature: 'Endurant').
	
	engine addOutputElement: world.

	^ world
]
