Extension { #name : 'MocoModel' }

{ #category : '*Moco-OpenPonk' }
MocoModel >> selectElementsOfKind: aClass ofStereotype: aString notGuarded: aSymbol [
	"Returns all elements of the given kind and UML stereotype that are not guarded by the given symbol."
	
	| collection |
	collection := elements select: [ :each | each isWrappingType: aClass ].
	
	aString ifNil: [ collection := collection reject: [ :each | each innerElement appliedStereotypes isNotEmpty ] ]
		ifNotNil: [ collection := collection select: [ :each | each innerElement appliedStereotypes anySatisfy: [ :e | (e class name) = aString ] ] ].
		
	collection := collection reject: [ :each | each meta checkGuard: aSymbol ].
	
	^ self class collectElements: collection
]
