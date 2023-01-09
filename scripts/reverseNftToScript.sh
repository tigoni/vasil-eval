cardano-cli transaction build-raw \
    --babbage-era \
    --tx-in 2861d0acca5a5dc081e70ac019ad1f37391a6f91c5a469fb98355abb28b6e724#0  \
    --tx-in 6118692cbbbf9143e11d72fd67e3c4fc8fd67d577d14e3aa9222bc1e24ea76b1#1  \
    --tx-in 6b900fcc5b37a0e43cb9b2ce8da3f390e0009ea076169f3698595eca975961c2#1  \
    --tx-in 6e129631887a0df74512ba4ef54c78b51222578e375b95a6fa025ae563a5f4b8#3  \
    --tx-in 6e129631887a0df74512ba4ef54c78b51222578e375b95a6fa025ae563a5f4b8#0  \
    --tx-out-datum-hash-file "../af/lock-script/unit.json" \
    --tx-out $(cat ../wallets/scripts/test08.addr)+7988528+" 1 a1e1afeb55ce2fc39b66e3ff87594333393a634ed2d15660d9fdfd81.54455354233032 + 1 2240d8bde3a426f8b714d277fc614df2545bc9e026d9863cf03d69c9.44594e415354592d42415941" \
    --out-file "../af/lock-script/txs/tx.raw" \
    --fee 177865

cardano-cli transaction sign \
--signing-key-file "../wallets/buyer/buyer.skey" \
--tx-body-file  "../af/lock-script/txs/tx.raw" \
--out-file "../af/lock-script/txs/tx.signed"  \
--$TS 

cardano-cli transaction submit --tx-file "../af/lock-script/txs/tx.signed" --$TS 
