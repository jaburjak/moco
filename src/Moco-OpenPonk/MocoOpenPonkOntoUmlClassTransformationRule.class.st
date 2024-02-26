"
Transforms an OpenPonk OntoUML class into its Moco counterpart.
"
Class {
	#name : #MocoOpenPonkOntoUmlClassTransformationRule,
	#superclass : #MocoTransformationRule,
	#category : #'Moco-OpenPonk-Rule'
}

{ #category : #'private - accessing' }
MocoOpenPonkOntoUmlClassTransformationRule class >> modelClass [
	^ MocoOntoUmlClass
]

{ #category : #'private - accessing' }
MocoOpenPonkOntoUmlClassTransformationRule class >> stereotypeSelector [
	^ nil
]

{ #category : #transforming }
MocoOpenPonkOntoUmlClassTransformationRule >> executeOn: anEngine [
	| kinds |

	kinds := MocoOpenPonkUmlQuery selectElementsFrom: (anEngine inModel) ofStereotype: ((self class stereotypeSelector) ifNil: [ nil ] ifNotNil: [ self class stereotypeSelector asString ]) ofClass: OPUMLClass.
	
	kinds do: [ :element |
		| outElement |
		outElement := MocoWrappedElement from: (self toMocoClass: element innerElement).
		
		anEngine outModel elements add: outElement.
		
		element meta outElements add: outElement.
		element meta exhausted: true.
			
		anEngine outModel meta didChange: true.
	]
]

{ #category : #accessing }
MocoOpenPonkOntoUmlClassTransformationRule >> priority [
	^ 100
]

{ #category : #'private - transforming' }
MocoOpenPonkOntoUmlClassTransformationRule >> toMocoClass: aClass [
	| moco |
	moco := (self class modelClass) new.
	
	MocoOpenPonkOntoUmlClassHelper initialize: moco from: aClass.
	
	^ moco
]
