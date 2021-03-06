module Intray.Cli.JSON
  ( writeJSON
  , readJSON
  ) where

import Import

import Data.Aeson as JSON
import Data.Aeson.Encode.Pretty as JSON
import qualified Data.ByteString.Lazy as LB

readJSON :: (MonadIO m, FromJSON a) => Path Abs File -> String -> m (Maybe a)
readJSON p extraErr =
  liftIO $
  forgivingAbsence $ do
    contents <- LB.readFile (toFilePath p)
    case JSON.eitherDecode contents of
      Left err ->
        die $
        unlines
          [unwords ["Unable to decode JSON file", fromAbsFile p, ", got error:", err], "", extraErr]
      Right a -> pure a

writeJSON :: (MonadIO m, ToJSON a) => Path Abs File -> a -> m ()
writeJSON p a =
  liftIO $ do
    ensureDir $ parent p
    LB.writeFile (toFilePath p) (JSON.encodePretty a)
