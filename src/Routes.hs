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



сheckTokenFromCookie :: Pool Connection -> Maybe T.Text -> IO Int
сheckTokenFromCookie pool h = do
      res <- (checkToken pool (fromMaybe "" (T.stripPrefix "token=" (fromMaybe "NoCookie" h))))
   --          IO [Only Int]      T.Text        Maybe T.Text           T.Text
      return $ (LI.head (map (\el -> fromOnly el) res))
--сheckTokenFromCookie pool h = liftIO (checkToken pool (fromMaybe "" (T.stripPrefix "token=" (fromMaybe "NoCookie" h))


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

    post "/method/getToken" $ do
      uName <- param "logLogin"
      pass <- param "logPass"
      resp <- liftIO $  (getToken pool uName pass)
      text (fromOnly (LI.head resp))

    get "/method/deactivateToken" $ do
      token <- param "token"
      resp <- liftIO (deactToken pool token)
      text "ok"

    get "/method/getPhotos" $ do
      uN <- param "userName" `rescue` (const next )
      photos <- liftIO $ getListPhotosWithName pool uN
      sendPhotosList photos
    
    get "/method/getPhotos" $ do
      t <- param "token" `rescue` (const next )
      photos <- liftIO $ getListPhotosWithToken pool t
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
    
    post "/method/uploadPhotoWithOrigin" $do
      us <- files
      origin <- param "originName"

      nphoto <- liftIO $ putPhotoToDbWithOrigin pool (T.pack(show (getFileName (getFileInfo us)))) origin
      liftAndCatchIO (L.writeFile (T.unpack (pathToFiles <> (fromOnly (LI.head nphoto)))) (getFileContent (getFileInfo us))) 
      text (fromOnly (LI.head nphoto))

    post "/method/publishPhoto" $ do
      uF <- param "image_src"
      publishPhoto pool uF
      text "ok"

    get "/wall" $ do
      h <- header "Cookie"
      resp <- liftIO (сheckTokenFromCookie pool h)
      if resp ==  1
        then showWall
        else redirect "/"

    get "/upload" $ do
      h <- header "Cookie"
      resp <- liftIO (сheckTokenFromCookie pool h)
      if resp ==  1
        then showUpload
        else redirect "/"

    get "/" $ do
      h <- header "Cookie"
      resp <- liftIO (сheckTokenFromCookie pool h)
      if resp ==  1
        then redirect "/wall"
        else showMainPage


  --get "/:w" $ do
  --    word <- param "w"
  --    file $ mconcat ["./src/html/", word]

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

showWall :: ActionM ()
showWall = do
    --setHeader "Content-Type" "text/html"
    file "./src/html/userpage.html"

showUpload :: ActionM ()
showUpload = do
    --setHeader "Content-Type" "text/html"
    file "./src/html/download.html"

redirectOnWall:: ActionM ()
redirectOnWall = redirect "/wall"
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
