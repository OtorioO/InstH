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
    get "/" $ do showMainPage
     
    get "/:w" $ do
     word <- param "w"
     file $ mconcat ["./src/html/", word]

    get "/u/:user" $ do
     --user <- param "user"
     file $ "./src/html/userpage.html"

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

    --post "/regAction" $ do register
        {-
        
        
        file $ "./src/html/index.html"

    get "/loginAction" $ do
        login <- param "login"
        password <- param "password"
	
        file $ "./src/html/index.html"
      -}

showMainPage :: ActionM ()
showMainPage = do
    setHeader "Content-Type" "text/html"
    file "./src/html/index.html"
{-}
registerInterest :: String -> IO (Maybe String)

register :: ActionM ()
register = do
    uName <- param "uName"
    login <- param "login"
    email <- param "email"
    password <- param "password"
   -- registered <- liftIO (registerInterest emailAddress)
    registered <- Just 
    case registered of
        Just errorMessage -> do
            json $ object [ "error" .= errorMessage ]
            status internalServerError500

        Nothing -> do
            json $ object [ "ok" .= ("ok" :: String) ]-}
