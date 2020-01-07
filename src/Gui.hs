module Gui(
 runGui
) where

import qualified Graphics.UI.Threepenny as UI
import Graphics.UI.Threepenny.Core
import Kmeans
import Control.Monad
import Data.Typeable
import Control.Applicative

canvasSize = 400
pointRadius = 5.0
centroidRadius = 2.5

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

  let pointStream = uncurry Point <$> UI.mousedown canvas

  let pointsStream = fmap (:) pointStream

  pointsBehaviour <- accumB [] pointsStream

  on UI.click clearButton $ const $ do
    UI.clearCanvas canvas

  on UI.click canvas $ const $ do
    UI.clearCanvas canvas

    partialPoints <- currentValue pointsBehaviour

    let points = fmap ($ None) partialPoints

    forM_ points $ \(Point x y color) -> do
      return canvas
        # set UI.strokeStyle (if color == Black then "black" else if color == Red then "red" else if color == Green then "green" else if color == Blue then "blue" else "")
      canvas # UI.beginPath
      canvas # UI.arc (fromIntegral x, fromIntegral y) pointRadius (-pi) pi
      canvas # UI.closePath
      canvas # UI.stroke

  on UI.click clusterButton $ const $ do
    UI.clearCanvas canvas

    points <- currentValue pointsBehaviour

    kmeansState <- liftIO (kmeans 4 (fmap ($ None) points))

    forM_ (clusters kmeansState) $ \(Point x y color) -> do
      return canvas
        # set UI.strokeStyle (if color == Black then "black" else if color == Red then "red" else if color == Green then "green" else if color == Blue then "blue" else "")
      canvas # UI.beginPath
      canvas # UI.arc (fromIntegral x, fromIntegral y) pointRadius (-pi) pi
      canvas # UI.closePath
      canvas # UI.stroke

    forM_ (centroids kmeansState) $ \(Point x y color) -> do
      canvas # set' UI.fillStyle (UI.htmlColor (if color == Black then "black" else if color == Red then "red" else if color == Green then "green" else "blue"))
      canvas # UI.beginPath
      canvas # UI.arc (fromIntegral x, fromIntegral y) centroidRadius (-pi) pi
      canvas # UI.closePath
      canvas # UI.fill

  return ()
