cardano-cli transaction build-raw \
    --babbage-era \
    --tx-in bf292feecb204da0d6c54b402c4ab18b024f9b96c720127a15e1b0f93ca33c14#0  \
    --tx-out-datum-hash-file "../random-number.json" \
    --tx-out $(cat ../ref-input.addr)+100000000 \
    --tx-out  $(cat ../wallets/wallet1/w1.addr)+9899822135 \
    --out-file "../tx/tx.raw" \
    --fee 177865

cardano-cli transaction sign \
--signing-key-file "../wallets/wallet1/w1.skey" \
--tx-body-file  "../tx/tx.raw" \
--out-file "../tx/tx.signed"  \
--$TS 

cardano-cli transaction submit --tx-file "../tx/tx.signed" --$TS 
