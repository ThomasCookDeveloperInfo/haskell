{-# LANGUAGE CPP #-}
{-# LANGUAGE NoRebindableSyntax #-}
{-# OPTIONS_GHC -fno-warn-missing-import-lists #-}
module Paths_realworldhaskell (
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

bindir     = "/home/topcat/Desktop/haskell/.stack-work/install/x86_64-linux-tinfo6/99c850ee9a850e933fd4cb25434c649b0ab124ecb948359dd8dc2466910f9340/8.4.3/bin"
libdir     = "/home/topcat/Desktop/haskell/.stack-work/install/x86_64-linux-tinfo6/99c850ee9a850e933fd4cb25434c649b0ab124ecb948359dd8dc2466910f9340/8.4.3/lib/x86_64-linux-ghc-8.4.3/realworldhaskell-0.1.0.0-JFp90A7bRbDEzBtZlXUqzl-realworldhaskell-exe"
dynlibdir  = "/home/topcat/Desktop/haskell/.stack-work/install/x86_64-linux-tinfo6/99c850ee9a850e933fd4cb25434c649b0ab124ecb948359dd8dc2466910f9340/8.4.3/lib/x86_64-linux-ghc-8.4.3"
datadir    = "/home/topcat/Desktop/haskell/.stack-work/install/x86_64-linux-tinfo6/99c850ee9a850e933fd4cb25434c649b0ab124ecb948359dd8dc2466910f9340/8.4.3/share/x86_64-linux-ghc-8.4.3/realworldhaskell-0.1.0.0"
libexecdir = "/home/topcat/Desktop/haskell/.stack-work/install/x86_64-linux-tinfo6/99c850ee9a850e933fd4cb25434c649b0ab124ecb948359dd8dc2466910f9340/8.4.3/libexec/x86_64-linux-ghc-8.4.3/realworldhaskell-0.1.0.0"
sysconfdir = "/home/topcat/Desktop/haskell/.stack-work/install/x86_64-linux-tinfo6/99c850ee9a850e933fd4cb25434c649b0ab124ecb948359dd8dc2466910f9340/8.4.3/etc"

getBinDir, getLibDir, getDynLibDir, getDataDir, getLibexecDir, getSysconfDir :: IO FilePath
getBinDir = catchIO (getEnv "realworldhaskell_bindir") (\_ -> return bindir)
getLibDir = catchIO (getEnv "realworldhaskell_libdir") (\_ -> return libdir)
getDynLibDir = catchIO (getEnv "realworldhaskell_dynlibdir") (\_ -> return dynlibdir)
getDataDir = catchIO (getEnv "realworldhaskell_datadir") (\_ -> return datadir)
getLibexecDir = catchIO (getEnv "realworldhaskell_libexecdir") (\_ -> return libexecdir)
getSysconfDir = catchIO (getEnv "realworldhaskell_sysconfdir") (\_ -> return sysconfdir)

getDataFileName :: FilePath -> IO FilePath
getDataFileName name = do
  dir <- getDataDir
  return (dir ++ "/" ++ name)
