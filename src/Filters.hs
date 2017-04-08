{-# LANGUAGE
FlexibleContexts, ScopedTypeVariables, BangPatterns, MagicHash,
QuasiQuotes #-}
module Filters
    ( 
    ) where


import Prelude as P
import Control.Monad
import Data.Int
import Data.Word
import GHC.Exts
import GHC.Word
import System.Environment
import System.IO
import System.Directory
import Graphics.GD
import Graphics.Filters.GD
import Graphics.Filters.Util
import System.FilePath (takeExtension)
import Data.Char




maybefilters :: String -> String -> IO ()
maybefilters imgin imgout = 
	 withImage  (case (map toLower $ takeExtension imgin) of
                          ".jpg" -> loadJpegFile imgin  
                          ".png" -> loadPngFile imgin 
                          ".gif" -> loadGifFile imgin ) 
		   (\x -> do
                     --do something
                     saveJpegFile 95 imgout x
                     putStrLn "OK")
	
