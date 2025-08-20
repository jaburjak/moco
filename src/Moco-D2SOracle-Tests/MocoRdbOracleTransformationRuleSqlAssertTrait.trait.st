"
Provides utility method for asserting equality of SQL statements.
"
Trait {
	#name : 'MocoRdbOracleTransformationRuleSqlAssertTrait',
	#category : 'Moco-D2SOracle-Tests-Trait',
	#package : 'Moco-D2SOracle-Tests',
	#tag : 'Trait'
}

{ #category : 'private - processing' }
MocoRdbOracleTransformationRuleSqlAssertTrait classSide >> normalizeSql: aString [
	"Removes all whitespace from the given string."
	
	| normalized |
	normalized := aString copyReplaceAll: ' ' with: ''.
	normalized := normalized copyReplaceAll: (Character cr asString) with: ''.
	normalized := normalized copyReplaceAll: (Character tab asString) with: ''.
	
	^ normalized
]

{ #category : 'asserting' }
MocoRdbOracleTransformationRuleSqlAssertTrait >> assertSql: aStatement equals: aString [
	"Asserts that the given Moco SQL statement element equals the given SQL string."
	
	| actual expected |
	actual := String new writeStream.
	aStatement printSqlTo: actual.
	
	actual := actual contents.
	
	actual := self class normalizeSql: actual.
	expected := self class normalizeSql: aString.
	
	self assert: actual equals: expected
]
