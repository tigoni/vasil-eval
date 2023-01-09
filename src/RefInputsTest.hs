{-# LANGUAGE DataKinds             #-}
{-# LANGUAGE DeriveAnyClass        #-}
{-# LANGUAGE DeriveGeneric         #-}
{-# LANGUAGE FlexibleContexts      #-}
{-# LANGUAGE FlexibleInstances     #-}
{-# LANGUAGE MultiParamTypeClasses #-}
{-# LANGUAGE NamedFieldPuns        #-}
{-# LANGUAGE NoImplicitPrelude     #-}
{-# LANGUAGE OverloadedStrings     #-}
{-# LANGUAGE ScopedTypeVariables   #-}
{-# LANGUAGE TemplateHaskell       #-}
{-# LANGUAGE TypeApplications      #-}
{-# LANGUAGE TypeFamilies          #-}
{-# LANGUAGE TypeOperators         #-}

module RefInputsTest
  ( apiReferenceInputScript
  , scriptAsCbor
  , writeSerialisedScript
  ) where
import           Cardano.Api
import           Cardano.Api.Shelley             (PlutusScript (..))
import           Codec.Serialise
import qualified Data.ByteString.Lazy            as LBS
import qualified Data.ByteString.Short           as SBS
import qualified Plutus.V2.Ledger.Api            as PlutusV2
import qualified Plutus.V2.Ledger.Contexts       as PlutusV2
import qualified Plutus.Script.Utils.Typed       as Typed
import           Plutus.V2.Ledger.Tx
import qualified PlutusTx
import           PlutusTx.Prelude                as P hiding (unless, (.))

import qualified Prelude

{-# INLINABLE mkReferenceInputValidator #-}
mkReferenceInputValidator :: BuiltinData -> Integer -> PlutusV2.ScriptContext -> Bool
mkReferenceInputValidator  _ r ctx =
    traceIfFalse "token missing from input"  correctDatum

  where
    info :: PlutusV2.TxInfo
    info = PlutusV2.scriptContextTxInfo ctx

    correctDatum :: Bool
    correctDatum = getDatum == Just r

    getDatum :: Maybe Integer
    getDatum = case PlutusV2.txInfoReferenceInputs info of
      [reference] -> case txOutDatum $ PlutusV2.txInInfoResolved reference of
        NoOutputDatum       -> Nothing
        OutputDatumHash odh -> case PlutusV2.findDatum odh info of
                                 Just d  -> PlutusTx.fromBuiltinData $ PlutusV2.getDatum $ d
                                 Nothing -> Nothing
        OutputDatum     od  -> PlutusTx.fromBuiltinData $ PlutusV2.getDatum od
      _           -> Nothing

referenceInputValidator :: PlutusV2.Validator
referenceInputValidator = PlutusV2.mkValidatorScript
    ($$(PlutusTx.compile [|| wrap ||]))
  where
    wrap = Typed.mkUntypedValidator mkReferenceInputValidator

scriptAsCbor :: SBS.ShortByteString
scriptAsCbor = SBS.toShort $ LBS.toStrict $ serialise referenceInputValidator

script :: PlutusV2.Script
script = PlutusV2.unValidatorScript referenceInputValidator

referenceInputScriptAsShortBs :: SBS.ShortByteString
referenceInputScriptAsShortBs = SBS.toShort $ LBS.toStrict $ serialise script

apiReferenceInputScript :: PlutusScript PlutusScriptV2
apiReferenceInputScript = PlutusScriptSerialised referenceInputScriptAsShortBs

writeSerialisedScript :: Prelude.IO ()
writeSerialisedScript = do
       result <- writeFileTextEnvelope "reference-input.plutus" Nothing apiReferenceInputScript
       case result of
         Left err -> Prelude.print $ displayError err
         Right () -> Prelude.putStrLn $ "wrote script to file reference-input.plutus"
