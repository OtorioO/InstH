{-# LANGUAGE OverloadedStrings #-}
{-# LANGUAGE DeriveGeneric #-}

module Routes
    ( routes
    ) where

import Lib
import Web.Scotty
import qualified Web.Scotty as S
import Text.Blaze.Html.Renderer.Text
--import qualified Data.Text.Lazy as TL
import GHC.Generics
import Data.Aeson (FromJSON, ToJSON)

import Data.Monoid ((<>))
import Data.Monoid (mconcat)


data PhotoStruct = PhotoStruct  { 
                                userName :: String,
                                image_src :: String,
                                date :: String,
                                description :: String
                                } deriving (Show, Generic)
instance ToJSON PhotoStruct
instance FromJSON PhotoStruct

u1 :: PhotoStruct
u1 = PhotoStruct { userName = "u1", 
                    image_src = "test1.jpeg",
                    date = "1213",
                    description = "descr1"
                  }

u2 :: PhotoStruct
u2 = PhotoStruct { userName = "u2", 
                    image_src = "test2.jpeg",
                    date = "12",
                    description = "descr2"
                  }

allPhoto :: [PhotoStruct]
allPhoto = [u1, u2]


blaze = S.html . renderHtml

routes :: ScottyM ()
routes = do
   {- post "/test" $ do
     beam <- param "num"
     blaze . Lib.test $ beam
    get "/test" $ do
     blaze . Lib.test $ -1
    get "/1.js" $
     file "1.js" -}

    get "/method/getPhotos" $ do
      json allPhoto

    get "/" $ do 
        showMainPage
     
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

--getPhotos :: ActionM ()
--getPhotos = do 


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
