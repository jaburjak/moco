"
Base class for transformation rules that transform OntoUML classes into UML classes.
"
Class {
	#name : #MocoOntoUmlClassTransformationRule,
	#superclass : #MocoTransformationRule,
	#category : #'Moco-O2U-Rule'
}

{ #category : #'private - accessing' }
MocoOntoUmlClassTransformationRule class >> modelSelector [
	^ MocoOntoUmlClass
]

{ #category : #'private - accessing' }
MocoOntoUmlClassTransformationRule class >> umlClass [
	^ MocoUmlClass
]

{ #category : #transforming }
MocoOntoUmlClassTransformationRule >> execute [
	| classes |
	classes := engine input
		selectElementsOfKind: (self class modelSelector)
		notGuarded: #MocoOntoUmlClassTransformationRule.
	
	classes do: [ :each | self transformClass: each ]
]

{ #category : #accessing }
MocoOntoUmlClassTransformationRule >> priority [
	^ 95
]

{ #category : #'private - transforming' }
MocoOntoUmlClassTransformationRule >> toUmlAttribute: aMocoOntoUmlAttribute [
	"Transforms the given OntoUML class attribute to a UML class attribute."
	
	| uml |
	uml := MocoUmlAttribute new
		name: (aMocoOntoUmlAttribute name);
		static: (aMocoOntoUmlAttribute static);
		immutable: (aMocoOntoUmlAttribute immutable);
		visibility: (aMocoOntoUmlAttribute visibility).
	
	aMocoOntoUmlAttribute type ifNotNil: [ uml type: (MocoUmlType newFromName: (aMocoOntoUmlAttribute type name)) ].
	
	uml multiplicity lower: (aMocoOntoUmlAttribute multiplicity lower).
	uml multiplicity upper: (aMocoOntoUmlAttribute multiplicity upper).
	
	^ uml
]

{ #category : #'private - transforming' }
MocoOntoUmlClassTransformationRule >> toUmlClass: aMocoOntoUmlClass [
	"Returns a UML class created from the given OntoUML class."
	
	| uml |
	
	uml := (self class umlClass) new.
	uml name: (aMocoOntoUmlClass name);
		abstract: (aMocoOntoUmlClass abstract).
	
	uml attributes addAll: (aMocoOntoUmlClass attributes collect: [ :each | self toUmlAttribute: each ]).
	
	^ uml
]

{ #category : #'private - transforming' }
MocoOntoUmlClassTransformationRule >> transformClass: aMocoOntoUmlClass [
	"Transforms the given OntoUML class to a UML class."
	
	| uml |
	uml := self toUmlClass: aMocoOntoUmlClass.
	
	engine addOutputElement: uml withSource: aMocoOntoUmlClass.
	engine input guard: aMocoOntoUmlClass with: #MocoOntoUmlClassTransformationRule
]
