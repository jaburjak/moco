"
Transforms table definition into a CREATE TABLE statement.
"
Class {
	#name : #MocoRdbTableTransformationRule,
	#superclass : #MocoTransformationRule,
	#instVars : [
		'typeResolver'
	],
	#category : #'Moco-D2S-Rule'
}

{ #category : #transforming }
MocoRdbTableTransformationRule >> execute [
	| tables |

	tables := (engine inModel elements select: [ :e | e isWrappingType: MocoRdbTable ]) select: [ :e | e meta isNotProcessedBy: #MocoRdbTableTransformationRule ].
	
	tables do: [ :element |
		| outElement |
		outElement := MocoWrappedElement from: (self toCreateTable: element innerElement).
		
		engine outModel elements add: outElement.
		
		element meta outElements add: outElement.
		element meta markProcessedBy: #MocoRdbTableTransformationRule.
			
		engine outModel meta didChange: true.
	]
]

{ #category : #initialization }
MocoRdbTableTransformationRule >> initialize [
	super initialize.
	
	typeResolver := MocoSqlOracleDataTypeResolver new
]

{ #category : #accessing }
MocoRdbTableTransformationRule >> priority [
	^ 100
]

{ #category : #'private - processing' }
MocoRdbTableTransformationRule >> toColumnDefinition: aMocoRdbColumn [
	| str |
	str := String new writeStream.
	
	str
		nextPutAll: (MocoSqlOracleEscaping escapeName: (aMocoRdbColumn name));
		nextPutAll: ' ';
		nextPutAll: (self toTypeDeclaration: (aMocoRdbColumn type)).
		
	^ str contents
]

{ #category : #'private - transforming' }
MocoRdbTableTransformationRule >> toCreateTable: aMocoRdbTable [
	| sql |
	sql := MocoSqlOracleCreateTable new.
	sql name: aMocoRdbTable name.
	
	sql columnDefinitions addAll: (aMocoRdbTable columns collect: [ :each | self toColumnDefinition: each ]).
	
	(sql constraintDefinitions)
		addAll: (self toPrimaryKeyDefinitions: aMocoRdbTable);
		addAll: (self toUniqueKeyDefinitions: aMocoRdbTable).
	
	^ sql
]

{ #category : #'private - processing' }
MocoRdbTableTransformationRule >> toPrimaryKeyDefinitions: aMocoRdbTable [
	| keys |
	keys := aMocoRdbTable constraints select: [ :each | each isKindOf: MocoRdbPrimaryKey ].
	
	^ keys collect: [ :each |
		(MocoSqlOracleEscaping escapeName: (each name)) , ' PRIMARY KEY (' , (', ' join: (each columns collect: [ :c | MocoSqlOracleEscaping escapeName: (c name) ])) , ')'
	]
]

{ #category : #'private - processing' }
MocoRdbTableTransformationRule >> toTypeDeclaration: aMocoRdbDataType [
	aMocoRdbDataType accept: typeResolver.
	
	^ typeResolver typeDeclaration
]

{ #category : #'private - processing' }
MocoRdbTableTransformationRule >> toUniqueKeyDefinitions: aMocoRdbTable [
	| keys |
	keys := aMocoRdbTable constraints select: [ :each | each isKindOf: MocoRdbUniqueKey ].
	
	^ keys collect: [ :each |
		(MocoSqlOracleEscaping escapeName: (each name)) , ' UNIQUE (' , (', ' join: (each columns collect: [ :c | MocoSqlOracleEscaping escapeName: (c name) ])) , ')'
	]
]
