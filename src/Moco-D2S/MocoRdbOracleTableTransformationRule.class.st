"
Transforms table definition into a CREATE TABLE statement.
"
Class {
	#name : #MocoRdbOracleTableTransformationRule,
	#superclass : #MocoTransformationRule,
	#category : #'Moco-D2S-Rule'
}

{ #category : #transforming }
MocoRdbOracleTableTransformationRule >> execute [
	| tables |

	tables := (engine inModel elements select: [ :e | e isWrappingType: MocoRdbTable ]) select: [ :e | e meta isNotProcessedBy: #MocoRdbOracleTableTransformationRule ].
	
	tables do: [ :element |
		| outElement |
		outElement := MocoWrappedElement from: (self toCreateTable: element innerElement).
		
		engine outModel elements add: outElement.
		
		element meta outElements add: outElement.
		element meta markProcessedBy: #MocoRdbOracleTableTransformationRule.
			
		engine outModel meta didChange: true.
	]
]

{ #category : #'as yet unclassified' }
MocoRdbOracleTableTransformationRule >> toCreateTable: aTable [
	| sql |
	sql := MocoSqlOracleCreateTable new.
	sql name: aTable name.
	
	^ sql
]
