{-# LANGUAGE CPP #-}
{-# OPTIONS_GHC -fno-warn-missing-import-lists #-}
{-# OPTIONS_GHC -fno-warn-implicit-prelude #-}
module Paths_nscotty (
    version,
    getBinDir, getLibDir, getDynLibDir, getDataDir, getLibexecDir,
    getDataFileName, getSysconfDir
  ) where

import qualified Control.Exception as Exception
import Data.Version (Version(..))
import System.Environment (getEnv)
import Prelude

#if defined(VERSION_base)

#if MIN_VERSION_base(4,0,0)
catchIO :: IO a -> (Exception.IOException -> IO a) -> IO a
#else
catchIO :: IO a -> (Exception.Exception -> IO a) -> IO a
#endif

#else
catchIO :: IO a -> (Exception.IOException -> IO a) -> IO a
#endif
catchIO = Exception.catch

version :: Version
version = Version [0,1,0,0] []
bindir, libdir, dynlibdir, datadir, libexecdir, sysconfdir :: FilePath

bindir     = "/home/android/Documents/Programs/git/InstH/.stack-work/install/i386-linux/lts-8.4/8.0.2/bin"
libdir     = "/home/android/Documents/Programs/git/InstH/.stack-work/install/i386-linux/lts-8.4/8.0.2/lib/i386-linux-ghc-8.0.2/nscotty-0.1.0.0-KN6vSIsukDBFJIa4M1NUDm"
dynlibdir  = "/home/android/Documents/Programs/git/InstH/.stack-work/install/i386-linux/lts-8.4/8.0.2/lib/i386-linux-ghc-8.0.2"
datadir    = "/home/android/Documents/Programs/git/InstH/.stack-work/install/i386-linux/lts-8.4/8.0.2/share/i386-linux-ghc-8.0.2/nscotty-0.1.0.0"
libexecdir = "/home/android/Documents/Programs/git/InstH/.stack-work/install/i386-linux/lts-8.4/8.0.2/libexec"
sysconfdir = "/home/android/Documents/Programs/git/InstH/.stack-work/install/i386-linux/lts-8.4/8.0.2/etc"

getBinDir, getLibDir, getDynLibDir, getDataDir, getLibexecDir, getSysconfDir :: IO FilePath
getBinDir = catchIO (getEnv "nscotty_bindir") (\_ -> return bindir)
getLibDir = catchIO (getEnv "nscotty_libdir") (\_ -> return libdir)
getDynLibDir = catchIO (getEnv "nscotty_dynlibdir") (\_ -> return dynlibdir)
getDataDir = catchIO (getEnv "nscotty_datadir") (\_ -> return datadir)
getLibexecDir = catchIO (getEnv "nscotty_libexecdir") (\_ -> return libexecdir)
getSysconfDir = catchIO (getEnv "nscotty_sysconfdir") (\_ -> return sysconfdir)

getDataFileName :: FilePath -> IO FilePath
getDataFileName name = do
  dir <- getDataDir
  return (dir ++ "/" ++ name)