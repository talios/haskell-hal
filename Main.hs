{-# LANGUAGE OverloadedStrings, DeriveGeneric #-}
module Main where

import Text.Hal
import GHC.Generics
import Data.Aeson
import Data.Aeson.Encode.Pretty
import qualified Data.ByteString.Lazy as B

data Person = Person { firstName  :: String
                     , lastName   :: String
                     , age        :: Int
                     } deriving (Show, Generic)

instance ToJSON Person
instance Profile Person where
  profileOf p = Just "person"

main =
    let p  = Person "Mark" "Derricutt" 39
        r  = represent p "http://localhost/user/mark"
             `linkTo` (Link "blog" "http://www.theoryinpractice.net" $ Just "website")
             `linkTo` (Link "podcast" "http://www.illegalargument.com" $ Just "website")
    in B.putStr $ encodePretty r
