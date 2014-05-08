{-# LANGUAGE OverloadedStrings, DeriveGeneric #-}
module Text.Hal where

import GHC.Generics
import Data.Aeson
import Data.Aeson.Types
import Data.HashMap.Strict
import Data.Aeson.Encode.Pretty

data Link = Link { rel     :: String
                 , href    :: String
                 , profile :: Maybe String
                 } deriving (Show, Generic)

data Representation a = Representation [Link] a
                        deriving (Show, Generic)

instance FromJSON Link
instance ToJSON Link

class Profile a where
  profileOf :: a -> Maybe String

instance ToJSON a => ToJSON (Representation a) where
 toJSON (Representation links a) =
  let (Object jl) = toJSON a
  in object $ (toList jl) ++ ["_links"  .= links]

represent :: (Profile a, ToJSON a) => a -> String -> Representation a
represent val href = Representation [Link "self" href (profileOf val)] val

linkTo :: Representation a -> Link -> Representation a
linkTo (Representation links val) link = Representation (links ++ [link]) val
