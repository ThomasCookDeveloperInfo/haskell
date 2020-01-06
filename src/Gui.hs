module Gui(
 runGui
) where

import qualified Graphics.UI.Threepenny as UI
import Graphics.UI.Threepenny.Core
import Algorithms
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

  loadGraphButton <- UI.button #+ [string "Load graph"]

  clusterButton <- UI.button #+ [string "Cluster graph"]

  getBody window #+
    [
    column [element canvas],
    element canvas,
    element loadGraphButton,
    element clusterButton
    ]

  on UI.click loadGraphButton $ const $ do
    UI.clearCanvas canvas

    graph <- liftIO (readGraphFromFile "graph.txt")

    forM_ graph $ \(Point x y _) -> do
      canvas # set' UI.fillStyle (UI.htmlColor "teal")
      canvas # UI.beginPath
      canvas # UI.arc (fromIntegral x, fromIntegral y) nodeRadius (-pi) pi
      canvas # UI.closePath
      canvas # UI.fill

  on UI.click clusterButton $ const $ do
    graph <- liftIO (readGraphFromFile "graph.txt")

    return ()

  return ()
