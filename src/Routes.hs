{-# LANGUAGE OverloadedStrings #-}
{-# LANGUAGE DeriveGeneric #-}

module Routes
    ( routes
    ) where


import Lib
import Domen
import Db

import Web.Scotty

import qualified Web.Scotty as S
import Text.Blaze.Html.Renderer.Text
--import GHC.Generics
--import Data.Aeson (FromJSON, ToJSON)

--import Data.Monoid ((<>))
--import Data.Monoid (mconcat)

--import Database.PostgreSQL.Simple
--import Database.PostgreSQL.Simple.FromRow
import Control.Monad.IO.Class
import Control.Monad
import Control.Applicative
import Database.PostgreSQL.Simple
import Data.Pool(Pool, createPool, withResource)
import qualified Data.Text.Lazy as T
import Data.Maybe

import           Network.Wai.Parse (FileInfo)

blaze = S.html . renderHtml


sendPhotosList :: [PhotoStruct] -> ActionM ()
sendPhotosList photos = json photos

routes :: Pool Connection -> ScottyM ()
routes pool = do
   {- post "/test" $ do
     beam <- param "num"
     blaze . Lib.test $ beam
    get "/test" $ do
     blaze . Lib.test $ -1
    get "/1.js" $
     file "1.js" -}
    get "/method/getPhotos" $ do
      uN <- param "userName" `rescue` (const next )
      photos <- liftIO $ getListPhotosWithName pool uN
      sendPhotosList photos
      
    get "/method/getPhotos" $ do
      photos <- liftIO $ getListPhotos pool
      sendPhotosList photos

    post "/method/uploadPhoto" $ do
        us <- files
        --ofile <- (head us)
        text (T.pack (show (length us)))

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




{-
dosth :: String
dosth = do
        conn <- connect defaultConnectInfo {
            connectDatabase = "postgres",
            connectPassword = "iamadminpostgres",
            connectUser = "postgres",
            connectPort = 5432,
            connectHost = "localhost"
        }
        xs <- query_ conn "select 2+2"
        return "123"
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
