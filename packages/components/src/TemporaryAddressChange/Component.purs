module KSF.TemporaryAddressChange.Component where

import Prelude

import Control.Alt ((<|>))
import Data.DateTime (DateTime, adjust)
import Data.Either (Either(..))
import Data.JSDate (fromDateTime)
import Data.Maybe (Maybe(..), isNothing)
import Data.Nullable (toNullable)
import Data.Time.Duration as Time.Duration
import Data.Validation.Semigroup (unV)
import DatePicker.Component as DatePicker
import Effect (Effect)
import Effect.Aff (Aff)
import Effect.Aff as Aff
import Effect.Class (liftEffect)
import Effect.Class.Console as Console
import Effect.Now as Now
import KSF.Grid as Grid
import KSF.InputField.Component as InputField
import KSF.User as User
import KSF.ValidatableForm as VF
import Persona as Persona
import React.Basic (JSX, make)
import React.Basic as React
import React.Basic.DOM as DOM
import React.Basic.DOM.Events (preventDefault)
import React.Basic.Events (handler, handler_)

type State =
  { startDate     :: Maybe DateTime
  , minStartDate  :: Maybe DateTime
  , endDate       :: Maybe DateTime
  , minEndDate    :: Maybe DateTime
  , streetAddress :: Maybe String
  , zipCode       :: Maybe String
  , temporaryName :: Maybe String
  }

type Self = React.Self Props State

type Props =
  { subsno    :: Int
  , userUuid  :: Persona.UUID
  , onCancel  :: Effect Unit
  , onLoading :: Effect Unit
  , onSuccess :: Persona.Subscription -> Effect Unit
  , onError   :: Persona.InvalidDateInput -> Effect Unit
  }

data Action
  = SetStartDate (Maybe DateTime)
  | SetMinStartDate (Maybe DateTime)
  | SetEndDate (Maybe DateTime)

data AddressChangeFields
  = StreetAddress
  | Zip
  | TemporaryName
instance validatableFieldAddressChangeFields :: VF.ValidatableField AddressChangeFields where
  validateField field value _serverErrors = case field of
    StreetAddress -> VF.validateEmptyField field "Adress krävs." value
    Zip           -> VF.validateZipCode field value
    TemporaryName -> VF.noValidation value

type AddressChange =
  { streetAddress :: Maybe String
  , zipCode       :: Maybe String
  , temporaryName :: Maybe String
  }

temporaryAddressChange :: Props -> JSX
temporaryAddressChange = make component { initialState, render, didMount }

initialState :: State
initialState =
  { startDate: Nothing
  , minStartDate: Nothing
  , endDate: Nothing
  , minEndDate: Nothing
  , streetAddress: Nothing
  , zipCode: Nothing
  , temporaryName: Nothing
  }

component :: React.Component Props
component = React.createComponent "TemporaryAddressChange"

-- | Minimum temporary address change period is one week
calcMinEndDate :: Maybe DateTime -> Maybe DateTime
calcMinEndDate Nothing = Nothing
calcMinEndDate (Just startDate) = do
  let week = Time.Duration.Days 7.0
  adjust week startDate

didMount :: Self -> Effect Unit
didMount self = do
  now <- Now.nowDateTime
  -- We set the minimum start date two days ahead because of system issues.
  -- TODO: This could be set depending on the time of day
  let dayAfterTomorrow = adjust (Time.Duration.Days 2.0) now
  self.setState _ { minStartDate = dayAfterTomorrow }

render :: Self -> JSX
render self@{ state: { startDate, endDate, streetAddress, zipCode, temporaryName }} =
  DOM.div
    { className: "clearfix temporary-address-change--container"
    , children:
        [ Grid.row_
           [ DOM.div
               { className: "col col-11"
               , children: [ DOM.h3_ [ DOM.text "Gör tillfällig adressändring" ] ]
               }
           , DOM.div
               { className: "col-1 flex temporary-address-change--close-icon"
               , children: [ DOM.div { className: "close-icon" } ]
               , onClick: handler_ self.props.onCancel
               }
           , addressChangeForm
           ]
        ]
    }
  where
    addressChangeForm =
      DOM.form
          { onSubmit: handler preventDefault (\_ -> submitForm startDate endDate { streetAddress, zipCode, temporaryName })
          , children:
              [ startDayInput
              , endDayInput
              , addressInput
              , zipInput
              , cityInput
              , temporaryNameInput
              , DOM.div
                  { children: [ submitFormButton ]
                  , className: "mt2 clearfix"
                  }
              ]
          }

    startDayInput =
      dateInput
        self
        { action: \newStartDate ->
                    self.setState _
                      { startDate = newStartDate
                      , minEndDate = calcMinEndDate newStartDate
                      }
        , value: self.state.startDate
        , minDate: self.state.minStartDate
        , maxDate: Nothing
        , disabled: false
        , label: "Börjar från"
        }

    endDayInput =
      dateInput
        self
        { action: \newEndDate -> self.setState _ { endDate = newEndDate }
        , value: self.state.endDate
        , minDate: self.state.minEndDate
        , maxDate: Nothing
        , disabled: isNothing self.state.startDate
        , label: "Avslutas"
        }

    addressInput =
      InputField.inputField
        { type_: "text"
        , placeholder: "Gatuadress"
        , name: "address"
        , onChange: \newAddress -> self.setState _ { streetAddress = newAddress }
        , value: Nothing
        , label: "Gatuadress"
        , validationError: VF.inputFieldErrorMessage $ VF.validateField StreetAddress self.state.streetAddress []
        }

    zipInput =
      InputField.inputField
        { type_: "text"
        , placeholder: "Postnummer"
        , name: "zipCode"
        , onChange: \newZip -> self.setState _ { zipCode = newZip }
        , value: Nothing
        , label: "Postnummer"
        , validationError: VF.inputFieldErrorMessage $ VF.validateField Zip self.state.zipCode []
        }

    cityInput =
      InputField.inputField
        { type_: "text"
        , placeholder: "Stad"
        , name: "city"
        -- We don't care about the city input, as on the server side, the city is inferred by the zip code
        , onChange: \_ -> pure unit
        , value: Nothing
        , validationError: Nothing
        , label: "Stad"
        }

    temporaryNameInput =
      InputField.inputField
        { type_: "text"
        , placeholder: "Tillfällig namnändring eller C/O"
        , name: "temporaryName"
        , onChange: \newTemporaryName -> self.setState _ { temporaryName = newTemporaryName }
        , value: Nothing
        , validationError: Nothing
        , label: "Tillfällig namnändring eller C/O"
        }

    submitFormButton =
      Grid.columnThird $
        DOM.button
          { type: "submit"
          , children: [ DOM.text "Skicka" ]
          , className: "button-green"
          }

    submitForm :: Maybe DateTime -> Maybe DateTime -> AddressChange -> Effect Unit
    submitForm (Just startDate') (Just endDate') addressChangeFormValues = do
      Aff.launchAff_ do
        unV
          -- Shows validation errors if submit button is pushed with uninitialized values
          (\_ -> liftEffect $ self.setState _
                    { streetAddress = self.state.streetAddress <|> Just ""
                    , zipCode = self.state.zipCode             <|> Just ""
                    })
          makeTemporaryAddressChange
          (validateTemporaryAddressChangeForm addressChangeFormValues)
      where
        makeTemporaryAddressChange :: AddressChange -> Aff Unit
        makeTemporaryAddressChange { streetAddress: Just streetAddress'
                                   , zipCode: Just zipCode'
                                   , temporaryName: temporaryName'
                                   } = do
          liftEffect $ self.props.onLoading
          User.temporaryAddressChange self.props.userUuid self.props.subsno startDate' endDate' streetAddress' zipCode' temporaryName' >>=
            case _ of
              Right sub -> liftEffect $ self.props.onSuccess sub
              Left invalidDateInput -> liftEffect $ self.props.onError invalidDateInput
        makeTemporaryAddressChange _ = Console.error "Form should be valid, however it looks like it's not"
    submitForm _ _ _ = Console.error "Temporary address change dates were not defined."

type DateInputField =
  { action   :: Maybe DateTime -> Effect Unit
  , value    :: Maybe DateTime
  , minDate  :: Maybe DateTime
  , maxDate  :: Maybe DateTime
  , disabled :: Boolean
  , label    :: String
  }

dateInput :: Self -> DateInputField -> JSX
dateInput self { action, value, minDate, maxDate, disabled, label } =
  Grid.row
    [ Grid.row_ [ DOM.label_ [ DOM.text label ] ]
    , Grid.row_
        [ DatePicker.datePicker
            { onChange: (action =<< _)
            , className: "temporary-address-change--date-picker"
            , value: toNullable $ fromDateTime <$> value
            , format: "d.M.yyyy"
            , required: true
            , minDate: toNullable $ fromDateTime <$> minDate
            , maxDate: toNullable $ fromDateTime <$> maxDate
            , disabled
            , locale: "sv-FI"
            }
        ]
    ]
    $ Just { extraClasses: [ "mb2" ] }

validateTemporaryAddressChangeForm :: AddressChange -> VF.ValidatedForm AddressChangeFields AddressChange
validateTemporaryAddressChangeForm form =
  { streetAddress: _
  , zipCode: _
  , temporaryName: _
  }
  <$> VF.validateField StreetAddress form.streetAddress []
  <*> VF.validateField Zip form.zipCode []
  <*> VF.validateField TemporaryName form.temporaryName []
