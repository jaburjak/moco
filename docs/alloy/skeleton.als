module main

open world_structure[World]
open ontological_properties[World]
open util/relation
open util/sequniv
open util/ternary

abstract sig Endurant {}
sig Object extends Endurant {}
sig Aspect extends Endurant {}

fact additionalFacts {
    continuous_existence[exists]
    elements_existence[Endurant, exists]
}

fun visible : World->univ {
    exists
}

-- PLACE ALLOY TRANSFORMATION RESULT HERE

--run singleWorld for 10 but 1 World, 7 Int
--run linearWorlds for 10 but 3 World, 7 Int
--run multipleWorlds for 10 but 4 World, 7 Int
--run singleWorld for 20 but 1 World, 7 Int
--run linearWorlds for 20 but 3 World, 7 Int
--run multipleWorlds for 20 but 4 World, 7 Int
