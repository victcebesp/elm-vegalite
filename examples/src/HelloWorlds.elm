port module HelloWorlds exposing (elmToJS)

import Platform
import VegaLite exposing (..)


myFirstVis : Spec
myFirstVis =
    let
        data =
            dataFromColumns []
                << dataColumn "x" (nums [ 10, 20, 30 ])

        enc =
            encoding
                << position X [ pName "x", pQuant ]
    in
    toVegaLite [ title "Hello, World!" [], data [], enc [], circle [] ]


mySecondVis : Spec
mySecondVis =
    let
        data =
            dataFromUrl "https://vega.github.io/vega-lite/data/cars.json"

        enc =
            encoding
                << position X [ pName "Cylinders", pOrdinal ]
                << position Y [ pName "Miles_per_Gallon", pQuant ]
    in
    toVegaLite [ data [], enc [], circle [] ]


myOtherVis : Spec
myOtherVis =
    let
        data =
            dataFromUrl "https://vega.github.io/vega-lite/data/cars.json"

        enc =
            encoding
                << position X [ pName "Cylinders", pOrdinal ]
                << position Y [ pName "Miles_per_Gallon", pAggregate opMean, pQuant ]
    in
    toVegaLite [ data [], enc [], bar [] ]



{- This list comprises tuples of the label for each embedded visualization (here vis1, vis2 etc.)
   and corresponding Vega-Lite specification.
   It assembles all the listed specs into a single JSON object.
-}


mySpecs : Spec
mySpecs =
    combineSpecs
        [ ( "vis1", myFirstVis )
        , ( "vis2", mySecondVis )
        , ( "vis3", myOtherVis )
        ]



{- The code below is boilerplate for creating a headless Elm module that opens
   an outgoing port to Javascript and sends the specs to it.
-}


main : Program () Spec msg
main =
    Platform.worker
        { init = always ( mySpecs, elmToJS mySpecs )
        , update = \_ model -> ( model, Cmd.none )
        , subscriptions = always Sub.none
        }


port elmToJS : Spec -> Cmd msg
