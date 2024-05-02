"
Provides utility method for asserting equality of SQL statements.
"
Trait {
	#name : #MocoRdbTransformationRuleSqlAssertTrait,
	#category : #'Moco-D2S-Tests-Trait'
}

{ #category : #'private - processing' }
MocoRdbTransformationRuleSqlAssertTrait classSide >> normalizeSql: aString [
	"Removes all whitespace from the given string."
	
	| normalized |
	normalized := aString copyReplaceAll: ' ' with: ''.
	normalized := normalized copyReplaceAll: (Character cr asString) with: ''.
	normalized := normalized copyReplaceAll: (Character tab asString) with: ''.
	
	^ normalized
]

{ #category : #asserting }
MocoRdbTransformationRuleSqlAssertTrait >> assertSql: aStatement equals: aString [
	"Asserts that the given Moco SQL statement element equals the given SQL string."
	
	| actual expected |
	actual := String new writeStream.
	aStatement printSqlTo: actual.
	
	actual := actual contents.
	
	actual := self class normalizeSql: actual.
	expected := self class normalizeSql: aString.
	
	self assert: actual equals: expected
]
