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
import Data.Monoid ((<>))
import Data.Monoid (mconcat)

getListPhotos :: Pool Connection -> IO [PhotoStruct]
getListPhotos pool = do
  res <- fetchSimple pool "select user_name, image_src, date, description from user_photo" :: IO [(String, String, String, String)]
  return $ map (\(userName, isrc, date, descr) -> PhotoStruct userName isrc date descr) res

getListPhotosWithName :: Pool Connection -> String-> IO [PhotoStruct]
getListPhotosWithName pool uName = do
  res <- fetch pool (Only uName) ("select user_name, image_src, date, description from user_photo where user_name = ?") :: IO [(String, String, String, String)]
  return $ map (\(userName, isrc, date, descr) -> PhotoStruct userName isrc date descr) res


fetchSimple :: FromRow r => Pool Connection -> Query -> IO [r]
fetchSimple pool sql = withResource pool retrieve
       where retrieve conn = query_ conn sql

fetch :: (ToRow q, FromRow r) => Pool Connection -> q -> Query -> IO [r]
fetch pool args sql = withResource pool retrieve
      where retrieve conn = query conn sql args