-- | This module is a small PureScript wrapper around the react-date-picker package.
--   The original react-date-picker docs can be found in https://www.npmjs.com/package/react-date-picker
module DatePicker.Component where

import Prelude

import Data.DateTime (DateTime, adjust)
import Data.Function.Uncurried (Fn0, runFn0)
import Data.JSDate (JSDate, toDateTime)
import Data.JSDate as JSDate
import Data.Maybe (Maybe(..))
import Data.Nullable (Nullable, toMaybe)
import Data.Time.Duration (Minutes(..))
import Effect (Effect)
import Effect.Uncurried (EffectFn1, mkEffectFn1)
import Math (abs)
import React.Basic (JSX, ReactComponent)
import React.Basic as React
import React.Basic.DOM as DOM

foreign import datePicker_ :: Fn0 (ReactComponent DatePickerProps)

type Props =
  { onChange  :: Effect (Maybe DateTime) -> Effect Unit
  , className :: String
  , value     :: Nullable JSDate
  , format    :: String
  , required  :: Boolean
  , minDate   :: Nullable JSDate
  , maxDate   :: Nullable JSDate
  , disabled  :: Boolean
  , locale    :: String
  }

type DatePickerProps =
  { onChange  :: EffectFn1 (Nullable JSDate) Unit
  , className :: String
  , value     :: Nullable JSDate
  , format    :: String
  , required  :: Boolean
  , minDate   :: Nullable JSDate
  , maxDate   :: Nullable JSDate
  , disabled  :: Boolean
  , locale    :: String
  }

datePicker :: Props -> JSX
datePicker props =
  DOM.div
    { className: "date-picker--wrapper"
    , children: [ picker ]
    }
  where
    picker = React.element (runFn0 datePicker_) datePickerProps
    datePickerProps :: DatePickerProps
    datePickerProps =
      { className: props.className
      , value:     props.value
      , format:    props.format
      , required:  props.required
      , minDate:   props.minDate
      , maxDate:   props.maxDate
      , disabled:  props.disabled
      , locale:    props.locale
      , onChange:  mkEffectFn1 $ adjustTimezone >>> props.onChange
      }

-- | Glues current timezone to the JS date we get here.
--   Context:
--   The react-date-picker calls `Date​.prototype​.get​Time()` when processing the dates
--   in the calendar, and `Date​.prototype​.get​Time()` uses UTC for time representation.
--   Apparently this is not a bug, but a feature, of the react-date-picker:
--   https://github.com/wojtekmaj/react-calendar/issues/174#issuecomment-472108379
adjustTimezone :: Nullable JSDate -> Effect (Maybe DateTime)
adjustTimezone date
  | Just pickedDate <- toMaybe date
  , Just pickedDateTime <- toDateTime pickedDate
  = do
    offset <- JSDate.getTimezoneOffset pickedDate
    let offsetMinutes = Minutes (abs offset)
    pure $ adjust offsetMinutes pickedDateTime
  | otherwise = pure Nothing
