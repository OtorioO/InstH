{-# LANGUAGE OverloadedStrings #-}
{-# LANGUAGE DeriveGeneric #-}

module Domen where

import GHC.Generics
import Data.Aeson (FromJSON, ToJSON)


data PhotoStruct = PhotoStruct  {
                                userName :: String,
                                image_src :: String,
                                date :: String,
                                description :: String
                                } deriving (Show, Generic)

data UserInfo = UserInfo {
						 userN :: String,
						 realName :: String,
						 email :: String
						 } deriving (Show, Generic)


instance ToJSON PhotoStruct
instance FromJSON PhotoStruct

instance ToJSON UserInfo
instance FromJSON UserInfo