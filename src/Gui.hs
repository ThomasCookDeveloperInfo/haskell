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

  clusterButton <- UI.button #+ [string "Cluster"]

  clearButton <- UI.button #+ [string "Clear"]

  getBody window #+
    [
    column [element canvas],
    element canvas,
    element clusterButton,
    element clearButton
    ]

  let canvasClick = UI.mousedown canvas
      newPoint = (\(x, y) -> Point x y None) <$> (canvasClick)



  on UI.click clearButton $ const $
    UI.clearCanvas canvas

  on UI.click clusterButton $ const $ do

    let pointA = Point 10 10 None
    let pointB = Point 30 15 None
    let pointC = Point 45 30 None
    let pointD = Point 5 20 None
    let pointE = Point 45 10 None
    let pointF = Point 35 15 None
    let pointG = Point 5 60 None

    let pointA' = Point 100 100 None
    let pointB' = Point 110 110 None
    let pointC' = Point 100 110 None
    let pointD' = Point 110 120 None
    let pointE' = Point 120 120 None
    let pointF' = Point 140 130 None
    let pointG' = Point 50 80 None
    let unclusteredData = [pointA, pointB, pointC, pointD, pointE, pointF, pointG, pointA', pointB', pointC', pointD', pointE', pointF', pointG']

    kmeansState <- liftIO (kmeans 2 unclusteredData)

    forM_ (clusters kmeansState) $ \(Point x y color) -> do
      canvas # set' UI.fillStyle (UI.htmlColor (if color == Black then "black" else if color == Red then "red" else if color == Green then "green" else "blue"))
      canvas # UI.beginPath
      canvas # UI.arc (fromIntegral x, fromIntegral y) nodeRadius (-pi) pi
      canvas # UI.closePath
      canvas # UI.fill

  return ()
