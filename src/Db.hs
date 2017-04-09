{-# LANGUAGE OverloadedStrings #-}
{-# LANGUAGE DeriveGeneric #-}

module Db where

import Domen

import Control.Monad.IO.Class
import Control.Monad
import Control.Applicative
import Data.Pool(Pool, createPool, withResource)
import Database.PostgreSQL.Simple
import Database.PostgreSQL.Simple.FromRow
import qualified Data.Text.Lazy as TL
import Data.Text.Lazy (Text)
import Data.Monoid ((<>))
import Data.Monoid (mconcat)
import qualified Data.List as LI
import Web.Scotty (ActionM)
import GHC.Int

getListPhotos :: Pool Connection -> IO [PhotoStruct]
getListPhotos pool = do
  res <- fetchSimple pool "select user_name, image_src, date, description from user_photo where is_public = true" :: IO [(String, String, String, String)]
  return $ map (\(userName, isrc, date, descr) -> PhotoStruct userName isrc date descr) res

getListPhotosWithName :: Pool Connection -> String-> IO [PhotoStruct]
getListPhotosWithName pool uName = do
  res <- fetch pool (Only uName) ("select user_name, image_src, date, description from user_photo where is_public = true and user_name = ?") :: IO [(String, String, String, String)]
  return $ map (\(userName, isrc, date, descr) -> PhotoStruct userName isrc date descr) res


putPhotoToDb :: Pool Connection -> Text -> Text -> Text -> Text -> IO [Only Text]
putPhotoToDb pool fileName userName date descr = do
	res <- fetch pool [fileName, userName, date, descr] ("select add_photo (?, ?, ?, ?)") :: IO [Only Text]
	return res

publishPhoto :: Pool Connection -> Text -> ActionM ()
publishPhoto pool fileName = do
	liftIO $ execSql pool [fileName] "update user_table set is_public = true where image_src = ?"
	return ()

regUser :: Pool Connection -> Text -> Text -> Text-> Text-> IO [Only Int]
regUser pool uName uE rName pass = do
  res <- fetch pool [uName, pass, uE, rName] ("select * from reg_user(?,?,?,?)") :: IO [Only Int]
  return res

getToken :: Pool Connection -> Text -> Text -> IO [Only Text]
getToken pool uN uP = do
  res <- fetch pool [uN, uP] ("select * from get_token(?,?)") :: IO [Only Text]
  return res

deactToken ::  Pool Connection -> Text -> IO [Only Int]
deactToken pool token = do
  res <- fetch pool (Only token) "select deactivate_token(?)"
  return res

checkToken :: Pool Connection -> Text -> IO [Only Int]
checkToken pool token = do
  res <- fetch pool (Only token) ("select * from check_token(?)") :: IO [Only Int]
  return res

getListPhotosWithToken :: Pool Connection -> String-> IO [PhotoStruct]
getListPhotosWithToken pool t = do
  res <- fetch pool (Only t) ("select * from get_photos_token(?)") :: IO [(String, String, String, String)]
  return $ map (\(userName, isrc, date, descr) -> PhotoStruct userName isrc date descr) res



fetchSimple :: FromRow r => Pool Connection -> Query -> IO [r]
fetchSimple pool sql = withResource pool retrieve
       where retrieve conn = query_ conn sql

fetch :: (ToRow q, FromRow r) => Pool Connection -> q -> Query -> IO [r]
fetch pool args sql = withResource pool retrieve
      where retrieve conn = query conn sql args

execSql :: ToRow q => Pool Connection -> q -> Query -> IO GHC.Int.Int64
execSql pool args sql = withResource pool ins
       where ins conn = execute conn sql args