cardano-cli transaction build \
    --babbage-era \
    --tx-in e9e3d44e1c5e66039aca59aed78a3d62e97648695b353bebf1d8bbec91cc9f5b#1  \
    --tx-out $(cat ../wallets/wallet2/w2.addr)+100000000 \
    --tx-out-inline-datum-value 9008 \
    --change-address $(cat ../wallets/wallet1/w1.addr) \
    --out-file "../tx/tx.raw" \
    --$TS

cardano-cli transaction sign \
--signing-key-file "../wallets/wallet1/w1.skey" \
--tx-body-file  "../tx/tx.raw" \
--out-file "../tx/tx.signed"  \
--$TS 

cardano-cli transaction submit --tx-file "../tx/tx.signed" --$TS 
