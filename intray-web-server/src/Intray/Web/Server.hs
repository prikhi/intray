{-# LANGUAGE RecordWildCards #-}

module Intray.Web.Server
  ( intrayWebServer
  , makeIntrayApp
  ) where

import Import

import Control.Concurrent
import Control.Concurrent.Async (concurrently_)
import qualified Data.HashMap.Strict as HM
import qualified Network.HTTP.Client as Http
import Yesod

import Servant.Client (parseBaseUrl)

import qualified Intray.Server as API
import qualified Intray.Server.OptParse as API

import Intray.Web.Server.Application ()
import Intray.Web.Server.Foundation
import Intray.Web.Server.OptParse

intrayWebServer :: IO ()
intrayWebServer = do
  (DispatchServe ss, Settings) <- getInstructions
  pPrint ss
  concurrently_ (runIntrayWebServer ss) (runIntrayAPIServer ss)

runIntrayWebServer :: ServeSettings -> IO ()
runIntrayWebServer ss@ServeSettings {..} = do
  app <- makeIntrayApp ss
  warp serveSetPort app

makeIntrayApp :: ServeSettings -> IO App
makeIntrayApp ServeSettings {..} = do
  man <- Http.newManager Http.defaultManagerSettings
  tokens <- newMVar HM.empty
  burl <- parseBaseUrl $ "http://127.0.0.1:" ++ show (API.serveSetPort serveSetAPISettings)
  pure
    App
      { appHttpManager = man
      , appRoot = serveSetHost
      , appStatic = myStatic
      , appTracking = serveSetTracking
      , appVerification = serveSetVerification
      , appPersistLogins = serveSetPersistLogins
      , appLoginTokens = tokens
      , appAPIBaseUrl = burl
      }

runIntrayAPIServer :: ServeSettings -> IO ()
runIntrayAPIServer ss = do
  let apiServeSets = serveSetAPISettings ss
  API.runIntrayServer apiServeSets
