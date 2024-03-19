"
Transforms foreign keys to associations in OpenPonk’s class model.
"
Class {
	#name : #MocoOpenPonkRdbForeignKeyTransformationRule,
	#superclass : #MocoTransformationRule,
	#category : #'Moco-OpenPonk-Rule-Rdb'
}

{ #category : #'private - processing' }
MocoOpenPonkRdbForeignKeyTransformationRule >> determineSourceMultiplicity: aMocoRdbForeignKey inTable: aMocoRdbTable [
	| lower upper |
	lower := 0.
	
	upper := '*'.
	
	(aMocoRdbTable constraints anySatisfy: [ :each | (each isKindOf: MocoRdbUniqueKey) and: [ each columns anySatisfy: [ :c | (aMocoRdbForeignKey columns anySatisfy: [ :e | e == c ]) ] ] ])
		ifTrue: [ upper := 1 ].
		
	^ { lower. upper }
]

{ #category : #'private - processing' }
MocoOpenPonkRdbForeignKeyTransformationRule >> determineTargetMultiplicity: aMocoRdbForeignKey inTable: aMocoRdbTable [
	| lower upper |
	(aMocoRdbForeignKey columns anySatisfy: [ :each | each nullable not ])
		ifTrue: [ lower := 1 ]
		ifFalse: [ lower := 0 ].
	
	upper := 1.
		
	^ { lower. upper }
]

{ #category : #transforming }
MocoOpenPonkRdbForeignKeyTransformationRule >> execute [
	| tables |
	tables := engine inModel elements select: [ :each | (each isWrappingType: MocoRdbTable) and: [ each meta isNotProcessedBy: #MocoOpenPonkRdbForeignKeyTransformationRule ] ].
	tables := tables select: [ :each | each innerElement constraints anySatisfy: [ :c | c isKindOf: MocoRdbForeignKey ] ].
	
	tables do: [ :each |
		| constraints |
		constraints := each innerElement constraints select: [ :c | c isKindOf: MocoRdbForeignKey ].
		
		constraints do: [ :constraint |
			| association |
			association := self toOpenPonkAssociation: constraint inTable: (each innerElement).
			association := MocoWrappedElement from: association.
			
			each meta outElements add: association.
			engine outModel elements add: association.
		].
		
		each meta markProcessedBy: #MocoOpenPonkRdbForeignKeyTransformationRule
	].

	tables ifNotEmpty: [ engine outModel meta didChange: true ]
]

{ #category : #'private - processing' }
MocoOpenPonkRdbForeignKeyTransformationRule >> findOutClassFor: aMocoRdbTable [
	^ ((engine findOutElementsFor: aMocoRdbTable) select: [ :each | each isWrappingType: OPUMLClass ]) first innerElement
]

{ #category : #accessing }
MocoOpenPonkRdbForeignKeyTransformationRule >> priority [
	^ 90
]

{ #category : #'private - transforming' }
MocoOpenPonkRdbForeignKeyTransformationRule >> toOpenPonkAssociation: aMocoRdbForeignKey inTable: aMocoRdbTable [
	| op name multiplicity source target |
	op := OPUMLAssociation new.
	
	name := String new writeStream.
	aMocoRdbForeignKey printTo: name.
	
	op name: (name contents).
	
	source := OPUMLProperty new.
	multiplicity := self determineSourceMultiplicity: aMocoRdbForeignKey inTable: aMocoRdbTable.
	source type: (self findOutClassFor: aMocoRdbTable);
		lowerValue: (OPUMLLiteralInteger new value: (multiplicity first));
		upperValue: (OPUMLLiteralUnlimitedNatural new value: (multiplicity last)).
	
	target := OPUMLProperty new.
	multiplicity := self determineTargetMultiplicity: aMocoRdbForeignKey inTable: aMocoRdbTable.
	target type: (self findOutClassFor: (aMocoRdbForeignKey referencedTable));
		lowerValue: (OPUMLLiteralInteger new value: (multiplicity first));
		upperValue: (OPUMLLiteralUnlimitedNatural new value: (multiplicity last)).
	
	(op memberEnds) add: source; add: target.
	
	op ownedEnds add: source.
	
	(source type) ownedAttributes add: target.
		
	^ op
]