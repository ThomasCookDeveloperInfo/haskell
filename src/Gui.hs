module Gui(
 runGui
) where

import qualified Graphics.UI.Threepenny as UI
import Graphics.UI.Threepenny.Core
import Kmeans
import Control.Monad

canvasSize = 400
nodeRadius = 5.0

runGui :: IO ()
runGui = startGUI defaultConfig setup

setup :: Window -> UI ()
setup window = do
  return window # set title "Haskell GUI"

  canvas <- UI.canvas
    # set UI.height canvasSize
    # set UI.width canvasSize
    # set style [("border", "solid black 1px"), ("background", "#eee")]

  clusterButton <- UI.button #+ [string "Do kmeans"]

  getBody window #+
    [
    column [element canvas],
    element canvas,
    element clusterButton
    ]

  on UI.click clusterButton $ const $ do
    UI.clearCanvas canvas

    kmeansState <- liftIO (example)

    forM_ (clusters kmeansState) $ \(Point x y color) -> do
      canvas # set' UI.fillStyle (UI.htmlColor (if color == Black then "black" else if color == Red then "red" else if color == Green then "green" else "blue"))
      canvas # UI.beginPath
      canvas # UI.arc (fromIntegral x, fromIntegral y) nodeRadius (-pi) pi
      canvas # UI.closePath
      canvas # UI.fill

  return ()
