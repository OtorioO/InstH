{-# LANGUAGE OverloadedStrings #-}

import Routes
import Filters
import Web.Scotty
import qualified Web.Scotty as S
--import Text.Blaze.Html.Renderer.Text
--import qualified Data.Text.Lazy as TL

--import Data.Monoid (mconcat)

--blaze = S.html . renderHtml

main :: IO ()
main = do
  scotty 3000 routes
