{-# LANGUAGE OverloadedStrings #-}
{-# LANGUAGE DeriveGeneric #-}

module Routes
    ( routes
    ) where


import Lib
import Domen
import Db
import Filters

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

doFilter :: T.Text -> String -> String -> IO ()
doFilter nameFilter origin new = do
  case nameFilter of
    "kelvin" -> kelvin origin new
    "blackwhite" -> blackwhite origin new
    "negativfiltr" -> negativfiltr origin new
    "meanR" -> meanR origin new
    "embfilters" -> embfilters origin new
    "bright" -> bright origin new 50
    _ -> return ()


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
 

    get "/method/getUserInfo" $ do
      t <- param "token"
      info <-liftIO $ getUserInfoWithToken pool t
      json info

 {-   get "/method/testFilter" $ do
      origin <- param "originName"
      nphoto <- liftIO $ (putPhotoToDbWithOrigin pool "filename.jpg" origin)
      --res <- liftIO $ getRandFileName pool "jpg" ""
      liftIO (kelvin (T.unpack (pathToFiles <> origin)) (T.unpack (pathToFiles <> (fromOnly (LI.head nphoto)))))
    --text (fromOnly (LI.head nphoto))
      --liftIO (maybefilters (T.unpack (pathToFiles <> p1)) (T.unpack (pathToFiles <> p2)))
      --html ("<img src=\"../img/" <> (fromOnly (LI.head nphoto)) <> "\"></img>")-}


    get "/method/doFilter" $ do
      origin <- param "originName"
      nphoto <- liftIO $ (putPhotoToDbWithOrigin pool "image/jpeg" origin)
      nFiltr <- param "nameFilter"
      liftIO (doFilter nFiltr (T.unpack (pathToFiles <> origin)) (T.unpack (pathToFiles <> (fromOnly (LI.head nphoto)))))
      setHeader "Cache-Control" "no-store"
      text (fromOnly (LI.head nphoto))
      --html ("<img src=\"../img/" <> (fromOnly (LI.head nphoto)) <> "\"></img>")

    post "/method/uploadPhoto" $ do
      us <- files
      uN <- param "userName"
      date <- param "date"
      des <- param "description"
      
        --text (T.pack (show (length us)))
       -- text . T.pack $(show (getFileInfo (L.head us)))
      --text $ (T.pack(show (getFileName (getFileInfo us))) <> T.pack(show (getFileType (getFileInfo us))))

      nphoto <- liftIO $ putPhotoToDb pool (T.pack(show (getFileType (getFileInfo us)))) uN date des

      liftAndCatchIO (L.writeFile (T.unpack (pathToFiles <> (fromOnly (LI.head nphoto)))) (getFileContent (getFileInfo us))) 
      text (fromOnly (LI.head nphoto))
    
    
 {-   post "/method/uploadPhotoWithOrigin" $do
      us <- files
      origin <- param "originName"
      --text $ (T.pack(show (getFileName (getFileInfo us))) <> "  " <> T.pack(show (getFileType (getFileInfo us))))
      nphoto <- liftIO $ putPhotoToDbWithOrigin pool (T.pack(show (getFileType (getFileInfo us)))) origin
      liftAndCatchIO (L.writeFile (T.unpack (pathToFiles <> (fromOnly (LI.head nphoto)))) (getFileContent (getFileInfo us))) 
      text (fromOnly (LI.head nphoto))-}

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
