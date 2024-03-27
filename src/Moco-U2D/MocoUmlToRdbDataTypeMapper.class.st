"
Maps attribute data types in a UML model to database column data types.
"
Class {
	#name : #MocoUmlToRdbDataTypeMapper,
	#superclass : #Object,
	#instVars : [
		'mapping'
	],
	#classVars : [
		'Instance'
	],
	#category : #'Moco-U2D-Utils'
}

{ #category : #'instance creation' }
MocoUmlToRdbDataTypeMapper class >> instance [
	"Returns the singleton instance of this class."
	
	Instance ifNotNil: [ ^ Instance ].
	
	Instance := self new.
	
	^ Instance
]

{ #category : #initialization }
MocoUmlToRdbDataTypeMapper >> initialize [
	super initialize.
	
	mapping := Dictionary new.
	
	mapping
		at: #int put: MocoRdbTypeInteger;
		at: #integer put: MocoRdbTypeInteger;
		at: #uint put: MocoRdbTypeInteger;
		at: #long put: MocoRdbTypeInteger;
		at: #short put: MocoRdbTypeInteger;
		at: #string put: MocoRdbTypeVarchar;
		at: #date put: MocoRdbTypeDate;
		at: #datetime put: MocoRdbTypeDateTime;
		at: #timestamp put: MocoRdbTypeTimestamp;
		at: #bool put: MocoRdbTypeBoolean;
		at: #boolean put: MocoRdbTypeBoolean;
		at: #float put: MocoRdbTypeDouble;
		at: #double put: MocoRdbTypeDouble;
		at: #decimal put: MocoRdbTypeDouble;
		at: #number put: MocoRdbTypeDouble;
		at: #list put: MocoRdbTypeBlob;
		at: #map put: MocoRdbTypeBlob;
		at: #array put: MocoRdbTypeBlob;
		at: #sequence put: MocoRdbTypeBlob;
		at: #mixed put: MocoRdbTypeBlob;
		at: #object put: MocoRdbTypeBlob;
		at: #bytearray put: MocoRdbTypeBlob;
		at: #char put: MocoRdbTypeCharacter;
		at: #character put: MocoRdbTypeCharacter;
		at: #symbol put: MocoRdbTypeCharacter;
		at: #byte put: MocoRdbTypeCharacter
]

{ #category : #transforming }
MocoUmlToRdbDataTypeMapper >> map: aString [
	^ mapping at: (aString asLowercase asByteString) ifAbsent: [ nil ]
]
