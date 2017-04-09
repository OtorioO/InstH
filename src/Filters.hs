{-# LANGUAGE
FlexibleContexts, ScopedTypeVariables, BangPatterns, MagicHash,
QuasiQuotes #-}

module Filters where


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

embfilters :: String -> String -> IO ()
embfilters imgin imgout = 
	 withImage  (case (map toLower $ takeExtension imgin) of
                          ".jpg" -> loadJpegFile imgin  
                          ".png" -> loadPngFile imgin 
                          ".gif" -> loadGifFile imgin ) 
		   (\x -> do
                     emboss x
                     saveJpegFile 95 imgout x
                     putStrLn "OK")

kelvin :: String -> String -> IO ()
kelvin imgin imgout = 
	 withImage  (case (map toLower $ takeExtension imgin) of
                          ".jpg" -> loadJpegFile imgin  
                          ".png" -> loadPngFile imgin 
                          ".gif" -> loadGifFile imgin ) 
		   (\x -> do
                     colorize x  (255,153,0,50)
                     saveJpegFile 95 imgout x
                     putStrLn "OK")

meanR :: String -> String -> IO ()
meanR imgin imgout = 
	 withImage  (case (map toLower $ takeExtension imgin) of
                          ".jpg" -> loadJpegFile imgin  
                          ".png" -> loadPngFile imgin 
                          ".gif" -> loadGifFile imgin ) 
		   (\x -> do
                     meanRemoval x
                     saveJpegFile 95 imgout x
                     putStrLn "OK")

negativfiltr :: String -> String -> IO ()
negativfiltr imgin imgout = 
	 withImage  (case (map toLower $ takeExtension imgin) of
                          ".jpg" -> loadJpegFile imgin  
                          ".png" -> loadPngFile imgin 
                          ".gif" -> loadGifFile imgin ) 
		   (\x -> do
                     negative x
                     saveJpegFile 95 imgout x
                     putStrLn "OK")

blackwhite :: String -> String -> IO ()
blackwhite imgin imgout = 
	 withImage  (case (map toLower $ takeExtension imgin) of
                          ".jpg" -> loadJpegFile imgin  
                          ".png" -> loadPngFile imgin 
                          ".gif" -> loadGifFile imgin ) 
		   (\x -> do
                     grayscale x
		     colorize x  (0,0,0,1)
                     saveJpegFile 95 imgout x
                     putStrLn "OK")

bright :: String -> String -> Int -> IO ()
bright imgin imgout colvo = --контрастность
	 withImage  (case (map toLower $ takeExtension imgin) of
                          ".jpg" -> loadJpegFile imgin  
                          ".png" -> loadPngFile imgin 
                          ".gif" -> loadGifFile imgin ) 
		   (\x -> do
                     brightness x colvo
                     saveJpegFile 95 imgout x
                     putStrLn "OK")



	
