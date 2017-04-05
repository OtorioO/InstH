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


getListPhotos :: Pool Connection -> IO [PhotoStruct]
getListPhotos pool = do
  res <- fetchSimple pool "select user_name, image_src, date, description from user_photo" :: IO [(String, String, String, String)]
  return $ map (\(userName, isrc, date, descr) -> PhotoStruct userName isrc date descr) res

fetchSimple :: FromRow r => Pool Connection -> Query -> IO [r]
fetchSimple pool sql = withResource pool retrieve
       where retrieve conn = query_ conn sql