"
Transforms enumeration attributes and associations to simple string attributes with an enumeration constraint.
"
Class {
	#name : #MocoUmlEnumerationTransformationRule,
	#superclass : #MocoTransformationRule,
	#category : #'Moco-U2D-Rule-Preprocess'
}

{ #category : #'private - processing' }
MocoUmlEnumerationTransformationRule >> collapseAssociationsToAttributes: aMocoUmlEnumeration [
	"Removes associations to the given enumeration and replaces them with attributes in the originating classes."
	
	((engine output selectElementsOfKind: MocoUmlAssociation) select: [ :each | each anySideIncludes: aMocoUmlEnumeration ]) do: [ :association |
		| class enumerationSide attribute |
		((association source element) == aMocoUmlEnumeration)
			ifTrue: [
				class := association target element.
				enumerationSide := association source
			]
			ifFalse: [
				class := association source element.
				enumerationSide := association target
			].
		
		attribute := MocoUmlAttribute new.
		attribute name: ((OrderedCollection with: (enumerationSide name) with: (association name) with: (aMocoUmlEnumeration name)) detect: [ :each | each isNotEmpty ]);
			type: (MocoUmlType newFromName: (aMocoUmlEnumeration name)).
		attribute multiplicity lower value: (enumerationSide multiplicity lower value).
		attribute multiplicity upper value: (enumerationSide multiplicity upper value).
		
		class attributes add: attribute.
		engine removeOutputElement: association
	]
]

{ #category : #transforming }
MocoUmlEnumerationTransformationRule >> execute [
	| enumerations |
	enumerations := engine output
		selectElementsOfKind: MocoUmlEnumeration
		notGuarded: #MocoUmlEnumerationTransformationRule.
	
	enumerations do: [ :each | self transformEnumeration: each ]
]

{ #category : #'private - processing' }
MocoUmlEnumerationTransformationRule >> generateEnumerationConstraints: aMocoUmlEnumeration [
	"Adds enumeration constraints for all attributes referencing the given enumeration and changes their type to a simple string."
	
	(engine output selectElementsOfKind: MocoUmlClass) do: [ :class |
		(class attributes select: [ :each | (each type name) = (aMocoUmlEnumeration name) ]) do: [ :attribute |
			| ocl |
			attribute type: (MocoUmlType newFromName: 'String').
			ocl := self generateOcl: aMocoUmlEnumeration onAttribute: attribute inClass: class.
			engine addOutputElement: ocl withSource: aMocoUmlEnumeration
		]
	]
]

{ #category : #'private - processing' }
MocoUmlEnumerationTransformationRule >> generateOcl: aMocoUmlEnumeration onAttribute: aMocoUmlAttribute inClass: aMocoUmlClass [
	"Generates an OCL enumeration constraint from the given enumeration."
	
	| ocl |
	ocl := MocoOclEnumerationConstraint new.
	ocl context: aMocoUmlClass;
		attribute: aMocoUmlAttribute.
	ocl name: ('EN_' , aMocoUmlClass name , '_' , aMocoUmlAttribute name).
	
	ocl values addAll: (aMocoUmlEnumeration literals collect: [ :each | each name ]).
	
	^ ocl
]

{ #category : #accessing }
MocoUmlEnumerationTransformationRule >> priority [
	^ 30
]

{ #category : #'private - transforming' }
MocoUmlEnumerationTransformationRule >> transformEnumeration: aMocoUmlEnumeration [
	"Transforms attributes and associations that reference the given enumeration to simple string attributes with an enumeration constraint."
	
	self collapseAssociationsToAttributes: aMocoUmlEnumeration;
		generateEnumerationConstraints: aMocoUmlEnumeration.
	
	engine removeOutputElement: aMocoUmlEnumeration
]
