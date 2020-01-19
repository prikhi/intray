{-# LANGUAGE DataKinds #-}
{-# LANGUAGE DeriveGeneric #-}
{-# LANGUAGE FlexibleInstances #-}
{-# LANGUAGE MultiParamTypeClasses #-}
{-# LANGUAGE TypeOperators #-}
{-# OPTIONS_GHC -fno-warn-orphans #-}

module Intray.API.Protected.Item
  ( IntrayProtectedItemAPI
  , IntrayProtectedItemSite(..)
  , AuthCookie(..)
  , GetItemUUIDs
  , GetItems
  , GetShowItem
  , GetIntraySize
  , PostAddItem
  , GetItem
  , DeleteItem
  , ItemType(..)
  , TypedItem(..)
  , textTypedItem
  , TypedItemCase(..)
  , typedItemCase
  , ItemInfo(..)
  , Added(..)
  , Synced(..)
  , SyncRequest(..)
  , SyncResponse(..)
  , PostSync
  , HashedPassword
  , passwordHash
  , validatePassword
  , ItemUUID
  , Username
  , parseUsername
  , parseUsernameWithError
  , usernameText
  ) where

import Import

import Data.Mergeless

import Servant.API
import Servant.API.Generic
import Servant.Auth.Docs ()

import Intray.Data

import Intray.API.Protected.Item.Types
import Intray.API.Types

type IntrayProtectedItemAPI = ToServantApi IntrayProtectedItemSite

data IntrayProtectedItemSite route =
  IntrayProtectedItemSite
    { getShowItem :: !(route :- GetShowItem)
    , getIntraySize :: !(route :- GetIntraySize)
    , getItemUUIDs :: !(route :- GetItemUUIDs)
    , getItems :: !(route :- GetItems)
    , postAddItem :: !(route :- PostAddItem)
    , getItem :: !(route :- GetItem)
    , deleteItem :: !(route :- DeleteItem)
    , postSync :: !(route :- PostSync)
    }
  deriving (Generic)

-- | The item is not guaranteed to be the same one for every call if there are multiple items available.
type GetShowItem = ProtectAPI :> "show-item" :> Get '[ JSON] (Maybe (ItemInfo TypedItem))

-- | Show the number of items in the intray
type GetIntraySize = ProtectAPI :> "size" :> Get '[ JSON] Int

-- | The order of the items is not guaranteed to be the same for every call.
type GetItemUUIDs = ProtectAPI :> "uuids" :> Get '[ JSON] [ItemUUID]

-- | The order of the items is not guaranteed to be the same for every call.
type GetItems = ProtectAPI :> "items" :> Get '[ JSON] [ItemInfo TypedItem]

type PostAddItem = ProtectAPI :> "item" :> ReqBody '[ JSON] TypedItem :> Post '[ JSON] ItemUUID

type GetItem = ProtectAPI :> "item" :> Capture "uuid" ItemUUID :> Get '[ JSON] (ItemInfo TypedItem)

type DeleteItem = ProtectAPI :> "item" :> Capture "uuid" ItemUUID :> Delete '[ JSON] NoContent

type PostSync
   = ProtectAPI :> "sync" :> ReqBody '[ JSON] (SyncRequest ItemUUID TypedItem) :> Post '[ JSON] (SyncResponse ItemUUID TypedItem)
