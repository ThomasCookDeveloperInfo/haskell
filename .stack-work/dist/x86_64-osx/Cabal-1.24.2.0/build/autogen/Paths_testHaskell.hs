{-# LANGUAGE CPP #-}
{-# OPTIONS_GHC -fno-warn-missing-import-lists #-}
{-# OPTIONS_GHC -fno-warn-implicit-prelude #-}
module Paths_testHaskell (
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

bindir     = "/Users/thomascook/testHaskell/.stack-work/install/x86_64-osx/lts-9.0/8.0.2/bin"
libdir     = "/Users/thomascook/testHaskell/.stack-work/install/x86_64-osx/lts-9.0/8.0.2/lib/x86_64-osx-ghc-8.0.2/testHaskell-0.1.0.0-rJfTykrnANG4sb3MLkjDL"
dynlibdir  = "/Users/thomascook/testHaskell/.stack-work/install/x86_64-osx/lts-9.0/8.0.2/lib/x86_64-osx-ghc-8.0.2"
datadir    = "/Users/thomascook/testHaskell/.stack-work/install/x86_64-osx/lts-9.0/8.0.2/share/x86_64-osx-ghc-8.0.2/testHaskell-0.1.0.0"
libexecdir = "/Users/thomascook/testHaskell/.stack-work/install/x86_64-osx/lts-9.0/8.0.2/libexec"
sysconfdir = "/Users/thomascook/testHaskell/.stack-work/install/x86_64-osx/lts-9.0/8.0.2/etc"

getBinDir, getLibDir, getDynLibDir, getDataDir, getLibexecDir, getSysconfDir :: IO FilePath
getBinDir = catchIO (getEnv "testHaskell_bindir") (\_ -> return bindir)
getLibDir = catchIO (getEnv "testHaskell_libdir") (\_ -> return libdir)
getDynLibDir = catchIO (getEnv "testHaskell_dynlibdir") (\_ -> return dynlibdir)
getDataDir = catchIO (getEnv "testHaskell_datadir") (\_ -> return datadir)
getLibexecDir = catchIO (getEnv "testHaskell_libexecdir") (\_ -> return libexecdir)
getSysconfDir = catchIO (getEnv "testHaskell_sysconfdir") (\_ -> return sysconfdir)

getDataFileName :: FilePath -> IO FilePath
getDataFileName name = do
  dir <- getDataDir
  return (dir ++ "/" ++ name)
