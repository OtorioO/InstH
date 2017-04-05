{-# LANGUAGE OverloadedStrings #-}

import Routes

import Web.Scotty
import Database.PostgreSQL.Simple
import Data.Pool(Pool, createPool, withResource)


newConn :: IO Connection
newConn = connect defaultConnectInfo {
			            connectDatabase = "postgres",
			            connectPassword = "iamadminpostgres",
			            connectUser = "postgres",
			            connectPort = 5432,
			            connectHost = "localhost"
		        	}

main :: IO ()
main = do
  pool <- createPool (newConn) close 1 32 16
  scotty 3000 (routes pool)