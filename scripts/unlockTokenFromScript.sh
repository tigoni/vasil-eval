cardano-cli transaction build \
     --babbage-era \
    --tx-in fcb1b525c13c4fa00fe7bcf7fc66f15bf2158f6783badd40db5fdd6b1b3049b8#0 \
    --tx-in-datum-file "../af/unlock-script/unit.json" \
    --tx-in-redeemer-file "../af/unlock-script/unit.json" \
    --tx-in-script-file "../af/lock-script/test08.plutus" \
    --tx-out $(cat ../wallets/buyer/buyer.addr)+"1988528 lovelace + 1 a1e1afeb55ce2fc39b66e3ff87594333393a634ed2d15660d9fdfd81.54455354233032 + 1 2240d8bde3a426f8b714d277fc614df2545bc9e026d9863cf03d69c9.44594e415354592d42415941" \
    --tx-out $(cat ../wallets/beneficiary/beneficiary.addr)+2000000 \
    --tx-out $(cat ../wallets/minter/minter.addr)+2000000 \
    --tx-in-collateral "9428f7b885fbd43efcd8426213d7df0634cc7ea9f422cad84f55f2089c119b38#1" \
    --invalid-hereafter 3142038 \
    --change-address $(cat ../wallets/buyer/buyer.addr) \
    --protocol-params-file "../af/unlock-script/protocol-params.json" \
    --out-file "../af/unlock-script/txs/tx.body" \
    --$TS

cardano-cli transaction sign \
    --tx-body-file "../af/unlock-script/txs/tx.body" \
    --signing-key-file "../wallets/buyer/buyer.skey" \
    --$TS \
    --out-file "../af/unlock-script/txs/tx.signed"

cardano-cli transaction submit \
    --$TS \
   --tx-file "../af/unlock-script/txs/tx.signed"

