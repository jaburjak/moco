"
Transforms table definition into a CREATE TABLE statement.
"
Class {
	#name : #MocoRdbOracleTableTransformationRule,
	#superclass : #MocoTransformationRule,
	#category : #'Moco-D2S-Rule'
}

{ #category : #accessing }
MocoRdbOracleTableTransformationRule >> executeOn: anEngine [
	| tables |

	tables := (anEngine inModel elements select: [ :e | e isWrappingType: MocoRdbOracleTable ]) select: [ :e | e meta isNotProcessedBy: #MocoRdbOracleTableTransformationRule ].
	
	tables do: [ :element |
		| outElement |
		outElement := MocoWrappedElement from: (self toCreateTable: element innerElement).
		
		anEngine outModel elements add: outElement.
		
		element meta outElements add: outElement.
		element meta markProcessedBy: #MocoRdbOracleTableTransformationRule.
			
		anEngine outModel meta didChange: true.
	]
]

{ #category : #'as yet unclassified' }
MocoRdbOracleTableTransformationRule >> toCreateTable: aTable [
	| sql |
	sql := MocoSqlOracleCreateTable new.
	sql name: aTable name.
	
	^ sql
]
