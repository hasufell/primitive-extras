module PrimitiveExtras.UnliftedArray
where

import PrimitiveExtras.Prelude


{-# INLINE at #-}
at :: PrimUnlifted element => UnliftedArray element -> Int -> forall result. result -> (element -> result) -> result
at ua index none some =
  if sizeofUnliftedArray ua <= index
    then none
    else some (indexUnliftedArray ua index)

replicateIO :: PrimUnlifted a => Int -> IO a -> IO (UnliftedArray a)
replicateIO size elementIO =
  do
    array <- unsafeNewUnliftedArray size
    let
      loop index =
        if index < size
          then do
            element <- elementIO
            writeUnliftedArray array index element
            loop (succ index)
          else unsafeFreezeUnliftedArray array
      in loop 0

generate :: PrimUnlifted a => Int -> (Int -> IO a) -> IO (UnliftedArray a)
generate size elementIO =
  do
    array <- unsafeNewUnliftedArray size
    let
      loop index =
        if index < size
          then do
            element <- elementIO index
            writeUnliftedArray array index element
            loop (succ index)
          else unsafeFreezeUnliftedArray array
      in loop 0
