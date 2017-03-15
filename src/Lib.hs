{-# LANGUAGE OverloadedStrings #-}
module Lib
    ( test
    ) where



import Prelude
import qualified Prelude as P
import Data.Monoid (mempty)

import Database.PostgreSQL.Simple
import Control.Monad
import Control.Applicative

import Text.Blaze.Html4.Transitional
import qualified Text.Blaze.Html4.Transitional as H
import Text.Blaze.Html4.Transitional.Attributes
import qualified Text.Blaze.Html4.Transitional.Attributes as A

test :: Int -> Html
test n= do
    html $ do
        H.head $ do
            meta ! charset "utf-8"
            H.title "Главная страница"
        body $ do
            center $ h1 "Информация"
            form ! name "form0" ! action "test" ! method "post" $ do
                input ! type_ "text" ! name "num" ! size "20"
                input ! type_ "submit" ! name "submit" ! value "Query"
            br
            br
            "Response is"
            mblock n

mblock :: Int -> Html
mblock n = 
  let tename = n
  in
  if n >= 0
  then H.div ! A.id "resp" $ (toHtml $ tename) 
  else H.div ! A.id "resp" $ ""


