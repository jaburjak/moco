"
Works around the issue of not being able to save OpenPonk projects with models that contain typed attributes.
"
Class {
	#name : #MocoOpenPonkSaveWorkaround,
	#superclass : #Object,
	#category : #'Moco-OpenPonk-Utils'
}

{ #category : #processing }
MocoOpenPonkSaveWorkaround class >> applyTo: anOPProjectController [
	anOPProjectController controllers do: [ :each |
		self applyToController: each
	]
]

{ #category : #'private - processing' }
MocoOpenPonkSaveWorkaround class >> applyToController: anOPController [
	| elements attributes |
	elements := anOPController model packagedElements.
	
	attributes := ((elements
		select: [ :each | each isKindOf: OPUMLClass ])
		flatCollect: [ :each | each ownedAttributes ])
		reject: [ :each | each type isNil ].

	(attributes select: [ :each | each type isKindOf: OPUMLPrimitiveType ])
		do: [ :each |
			| element |
			element := elements detect: [ :e | ((e isKindOf: OPUMLClass) or: [ e isKindOf: OPUMLEnumeration ]) and: [ (each type name) = (e name) ] ] ifNone: [ nil ].
			
			element ifNotNil: [ each type: element ]
		].

	((attributes
		reject: [ :each | each type isKindOf: OPUMLPrimitiveType ])
		select: [ :each | elements noneSatisfy: [ :e | ((e isKindOf: OPUMLClass) or: [ e isKindOf: OPUMLEnumeration ]) and: [ (each type name) = (e name) ] ] ])
		do: [ :each | each type: (OPUMLPrimitiveType new name: (each type name); yourself) ]
]
