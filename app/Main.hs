{-# LANGUAGE OverloadedStrings #-}

import Lib
import Web.Scotty
import qualified Web.Scotty as S
import Text.Blaze.Html.Renderer.Text
--import qualified Data.Text.Lazy as TL

import Data.Monoid (mconcat)

blaze = S.html . renderHtml

main :: IO ()
main = do
  scotty 3000 $ do
   {- post "/test" $ do
     beam <- param "num"
     blaze . Lib.test $ beam
    get "/test" $ do
     blaze . Lib.test $ -1
    get "/1.js" $
     file "1.js" -}
    get "/" $ do
     file $ "./src/html/index.html"
    get "/:w" $ do
     word <- param "w"
     file $ mconcat ["./src/html/", word]
    get "/js/:w" $ do
     word <- param "w"
     file $ mconcat ["./src/html/js/", word]
    get "/img/:w" $ do
     word <- param "w"
     file $ mconcat ["./src/html/img/", word]
    get "/fonts/:w" $ do
     word <- param "w"
     file $ mconcat ["./src/html/fonts/", word]
    get "/css/:w" $ do
     word <- param "w"
     file $ mconcat ["./src/html/css/", word]


	
      
