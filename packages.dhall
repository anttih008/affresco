let upstream =
      https://raw.githubusercontent.com/purescript/package-sets/psc-0.13.0-20190626/src/packages.dhall sha256:9905f07c9c3bd62fb3205e2108515811a89d55cff24f4341652f61ddacfcf148

let overrides = {=}

let additions =
      { facebook =
          { dependencies =
            [ "console"
            , "aff"
            , "prelude"
            , "foreign"
            , "foreign-generic"
            , "errors"
            , "effect"
            ]
          , repo = "https://github.com/KSF-Media/purescript-facebook.git"
          , version = "e765b3fb5585b2d774cc6a12c412891be51ca5ed"
          }
      , react-basic-router =
          { dependencies =
            [ "react-basic"
            , "foreign-generic"
            , "prelude"
            ]
          , repo = "https://github.com/KSF-Media/purescript-react-basic-router.git"
          , version = "03b5ce8462f57d930929dc6d037b1093fece2128"
          }
      , affresco-components =
          ./packages/components/spago.dhall as Location
      , affresco-user =
          ./packages/user/spago.dhall as Location
      }

in  upstream // overrides // additions
