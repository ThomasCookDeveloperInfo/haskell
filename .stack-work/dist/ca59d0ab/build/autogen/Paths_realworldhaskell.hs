{-# LANGUAGE CPP #-}
{-# OPTIONS_GHC -fno-warn-missing-import-lists #-}
{-# OPTIONS_GHC -fno-warn-implicit-prelude #-}
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

bindir     = "C:\\Users\\info\\Desktop\\Projects\\haskell\\.stack-work\\install\\6c953ab2\\bin"
libdir     = "C:\\Users\\info\\Desktop\\Projects\\haskell\\.stack-work\\install\\6c953ab2\\lib\\x86_64-windows-ghc-8.0.2\\realworldhaskell-0.1.0.0-CFBhzg8kpWP4Csw99eH4yN"
dynlibdir  = "C:\\Users\\info\\Desktop\\Projects\\haskell\\.stack-work\\install\\6c953ab2\\lib\\x86_64-windows-ghc-8.0.2"
datadir    = "C:\\Users\\info\\Desktop\\Projects\\haskell\\.stack-work\\install\\6c953ab2\\share\\x86_64-windows-ghc-8.0.2\\realworldhaskell-0.1.0.0"
libexecdir = "C:\\Users\\info\\Desktop\\Projects\\haskell\\.stack-work\\install\\6c953ab2\\libexec"
sysconfdir = "C:\\Users\\info\\Desktop\\Projects\\haskell\\.stack-work\\install\\6c953ab2\\etc"

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
  return (dir ++ "\\" ++ name)
