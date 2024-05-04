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
	"Returns multiplicity at the source side of the association generated from the given foreign key."
	
	| lower upper |
	lower := 0.
	upper := '*'.
	
	((engine input selectElementsOfKind: MocoOclRdbMandatoryMultiplicityConstraint) anySatisfy: [ :each | aMocoRdbForeignKey columns anySatisfy: [ :c | c == (each sourceColumn) ] ])
		ifTrue: [ lower := 1 ].
	
	(aMocoRdbTable constraints anySatisfy: [ :each | ((each isKindOf: MocoRdbUniqueKey) or: [ each isKindOf: MocoRdbPrimaryKey ]) and: [ (each columns reject: [ :c | aMocoRdbForeignKey columns anySatisfy: [ :e | e == c ] ]) isEmpty ] ])
		ifTrue: [ upper := 1 ].
	
	((engine input selectElementsOfKind: MocoOclRdbSpecialMultiplicityConstraint) select: [ :each | aMocoRdbForeignKey columns anySatisfy: [ :c | c == (each sourceColumn) ] ]) do: [ :each |
		each lower ifNotNil: [ lower := each lower value ].
		each upper ifNotNil: [ upper := each upper value ]
	].
		
	^ { lower. upper }
]

{ #category : #'private - processing' }
MocoOpenPonkRdbForeignKeyTransformationRule >> determineTargetMultiplicity: aMocoRdbForeignKey inTable: aMocoRdbTable [
	"Returns multiplicity at the target side of the association generated from the given foreign key."
	
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
	tables := engine input
		selectElementsOfKind: MocoRdbTable
		notGuarded: #MocoOpenPonkRdbForeignKeyTransformationRule.
	tables := tables select: [ :each | each constraints anySatisfy: [ :c | c isKindOf: MocoRdbForeignKey ] ].
	
	tables do: [ :each | self transformTable: each ]
]

{ #category : #'private - processing' }
MocoOpenPonkRdbForeignKeyTransformationRule >> findOutClassFor: aMocoRdbTable [
	"Returns the class element that was generated from the given table."
	
	^ engine detectOutputElement: aMocoRdbTable ofKind: OPUMLClass
]

{ #category : #accessing }
MocoOpenPonkRdbForeignKeyTransformationRule >> priority [
	^ 90
]

{ #category : #'private - transforming' }
MocoOpenPonkRdbForeignKeyTransformationRule >> toOpenPonkAssociation: aMocoRdbForeignKey inTable: aMocoRdbTable [
	"Creates an OpenPonk association from the given foreign key that originates in the given database table."
	
	| op multiplicity source target |
	op := OPUMLAssociation new.
	
	op name: ('«FK» (' , (',' join: (aMocoRdbForeignKey columns collect: [ :each | each name ])) , '=' , (',' join: (aMocoRdbForeignKey referencedColumns collect: [ :each | each name ])) , ')').
	
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
	
	op ownedEnds addAll: (op memberEnds).
	
	op navigableOwnedEnds add: (op memberEnds second).
		
	^ op
]

{ #category : #'private - transforming' }
MocoOpenPonkRdbForeignKeyTransformationRule >> transformTable: aMocoRdbTable [
	"Transforms foreign keys in the given table to associations."
	
	| constraints |
	constraints := aMocoRdbTable constraints select: [ :each | each isKindOf: MocoRdbForeignKey ].
	
	constraints do: [ :each |
		| association |
		association := self toOpenPonkAssociation: each inTable: aMocoRdbTable.
		
		engine addOutputElement: association withSource: aMocoRdbTable
	].
	
	engine input guard: aMocoRdbTable with: #MocoOpenPonkRdbForeignKeyTransformationRule
]
