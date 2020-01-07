{-# LANGUAGE CPP #-}
{-# LANGUAGE NoRebindableSyntax #-}
{-# OPTIONS_GHC -fno-warn-missing-import-lists #-}
module Paths_haskell (
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

bindir     = "/home/topcat/Desktop/Repositories/haskell/.stack-work/install/x86_64-linux-tinfo6/30ce7849869e9f420819be512faa1df1d078cf884bae497894c8ba205e3ce037/8.6.5/bin"
libdir     = "/home/topcat/Desktop/Repositories/haskell/.stack-work/install/x86_64-linux-tinfo6/30ce7849869e9f420819be512faa1df1d078cf884bae497894c8ba205e3ce037/8.6.5/lib/x86_64-linux-ghc-8.6.5/haskell-0.1.0.0-4f75kyihSP82AIcekbO7jL"
dynlibdir  = "/home/topcat/Desktop/Repositories/haskell/.stack-work/install/x86_64-linux-tinfo6/30ce7849869e9f420819be512faa1df1d078cf884bae497894c8ba205e3ce037/8.6.5/lib/x86_64-linux-ghc-8.6.5"
datadir    = "/home/topcat/Desktop/Repositories/haskell/.stack-work/install/x86_64-linux-tinfo6/30ce7849869e9f420819be512faa1df1d078cf884bae497894c8ba205e3ce037/8.6.5/share/x86_64-linux-ghc-8.6.5/haskell-0.1.0.0"
libexecdir = "/home/topcat/Desktop/Repositories/haskell/.stack-work/install/x86_64-linux-tinfo6/30ce7849869e9f420819be512faa1df1d078cf884bae497894c8ba205e3ce037/8.6.5/libexec/x86_64-linux-ghc-8.6.5/haskell-0.1.0.0"
sysconfdir = "/home/topcat/Desktop/Repositories/haskell/.stack-work/install/x86_64-linux-tinfo6/30ce7849869e9f420819be512faa1df1d078cf884bae497894c8ba205e3ce037/8.6.5/etc"

getBinDir, getLibDir, getDynLibDir, getDataDir, getLibexecDir, getSysconfDir :: IO FilePath
getBinDir = catchIO (getEnv "haskell_bindir") (\_ -> return bindir)
getLibDir = catchIO (getEnv "haskell_libdir") (\_ -> return libdir)
getDynLibDir = catchIO (getEnv "haskell_dynlibdir") (\_ -> return dynlibdir)
getDataDir = catchIO (getEnv "haskell_datadir") (\_ -> return datadir)
getLibexecDir = catchIO (getEnv "haskell_libexecdir") (\_ -> return libexecdir)
getSysconfDir = catchIO (getEnv "haskell_sysconfdir") (\_ -> return sysconfdir)

getDataFileName :: FilePath -> IO FilePath
getDataFileName name = do
  dir <- getDataDir
  return (dir ++ "/" ++ name)
