{-# LANGUAGE FlexibleInstances #-}
{-# OPTIONS_GHC -fno-warn-orphans #-}
{-# OPTIONS_GHC -fno-warn-dodgy-exports #-}

module Intray.API.Gen
    ( module Intray.API.Gen
    , module Intray.API.Admin.Gen
    , module Intray.API.Protected.Gen
    ) where

import Import

import Intray.API
import Intray.Data.Gen ()

import Intray.API.Admin.Gen ()
import Intray.API.Protected.Gen ()

instance GenUnchecked Registration

instance GenValid Registration where
    genValid = genValidStructurally

instance GenUnchecked LoginForm

instance GenValid LoginForm where
    genValid = genValidStructurally
