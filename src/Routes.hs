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
--import Text.Blaze.Html.Renderer.Text
--import GHC.Generics
--import Data.Aeson (FromJSON, ToJSON)

import Data.Monoid ((<>))
--import Data.Monoid (mconcat)

--import Database.PostgreSQL.Simple
--import Database.PostgreSQL.Simple.FromRow
import Control.Monad.IO.Class
import Control.Monad
import Control.Applicative
import Database.PostgreSQL.Simple
import Data.Pool(Pool, createPool, withResource)
import qualified Data.Text.Lazy as T
import qualified Data.List as LI
import Data.Maybe
import qualified Data.ByteString as B
import qualified Data.ByteString.Lazy as L
import Network.Wai.Parse (FileInfo (..))

--blaze = S.html . renderHtml

pathToFiles :: T.Text
pathToFiles = "/home/android/Documents/Programs/git/InstH/src/html/img/"

sendPhotosList :: [PhotoStruct] -> ActionM ()
sendPhotosList photos = json photos


getFileInfo :: [File] -> FileInfo L.ByteString
getFileInfo file = snd (LI.head file)

getFileName :: FileInfo L.ByteString -> B.ByteString
getFileName  (FileInfo fileName _ _) = fileName

getFileType :: FileInfo L.ByteString  -> B.ByteString
getFileType (FileInfo _ fileType _) = fileType
 
getFileContent :: FileInfo L.ByteString -> L.ByteString
getFileContent (FileInfo _ _ content) = content




routes :: Pool Connection -> ScottyM ()
routes pool = do
   {- post "/test" $ do
     beam <- param "num"
     blaze . Lib.test $ beam
    get "/test" $ do
     blaze . Lib.test $ -1
    get "/1.js" $
     file "1.js" -}
    post "/method/regAction" $ do
      uName <- param "regLogin"
      uE <- param "regEmail"
      rName <- param "regRName"
      pass <- param "regPass"
      resp <- liftIO $ regUser pool uName uE rName pass
      text . T.pack $ (show (fromOnly (LI.head resp)))

    post "/method/loginAction" $ do
      text "Responding2"

    

    get "/method/getPhotos" $ do
      uN <- param "userName" `rescue` (const next )
      photos <- liftIO $ getListPhotosWithName pool uN
      sendPhotosList photos
      
    get "/method/getPhotos" $ do
      photos <- liftIO $ getListPhotos pool
      sendPhotosList photos

    post "/method/uploadPhoto" $ do
      us <- files
      uN <- param "userName"
      date <- param "date"
      des <- param "description"
      nphoto <- liftIO $ putPhotoToDb pool (T.pack(show (getFileName (getFileInfo us)))) uN date des

        --text (T.pack (show (length us)))
       -- text . T.pack $(show (getFileInfo (L.head us)))
      --text $ (T.pack(show (getFileName (getFileInfo us))) <> T.pack(show (getFileType (getFileInfo us))))
      liftAndCatchIO (L.writeFile (T.unpack (pathToFiles <> (fromOnly (LI.head nphoto)))) (getFileContent (getFileInfo us))) 
      text (fromOnly (LI.head nphoto))
    
    post "/method/publishPhoto" $ do
      uF <- param "image_src"
      publishPhoto pool uF

    get "/wall" $ do
     file $ "./src/html/userpage.html"

    get "/" $ do 
      showMainPage

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
