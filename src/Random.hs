module Random(
  RandomT
) where

import Data.Time.Clock.POSIX (getPOSIXTime)
import System.Random (StdGen, mkStdGen )
import Control.Monad
import Control.Monad.State

type RandomT = StateT StdGen

seedFromTime :: MonadIO m => m StdGen
seedFromTime = liftIO $ mkStdGen . round <$> getPOSIXTime
