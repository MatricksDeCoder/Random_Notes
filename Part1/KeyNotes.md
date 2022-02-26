## Notes and Key Points

- Consensus is a two part process (a) block production (b) block acceptance
- blockchain forms a tree structure and consensus is needed as to which path to follow 

- Ethash is the PoW algorithm for Ethereum 1.0. It is the latest version of Dagger-Hashimoto 
    - a seed is computed for each block by scanning through the block headers up until that point.
    - From the seed, one can compute a pseudorandom cache. Light clients store the cache
    - From the cache, we can generate a dataset, with the property that each item in the dataset depends on only a small number of items from the cache.
    - Full clients and miners store the dataset. 
    - The dataset grows linearly with time

- Block Valicaiton in Ethereum involved checking
    - previous block, timestamp , difficulty, block number, transaction list, proof of work, total gas consumed/gas limits, 
      merkle tree, blockheader etc validity 

- GHOST Protocol
    -  to adjust for fast Ethereum times which result in high stale rates of blocks not considered and wasted
    - largest proof of work is considered 
    - Transaction fees, however, are not awarded to uncles.

- EIP-2930
  - a transaction type which contains an access list, a list of addresses and storage keys
that the transaction plans to access. 
  - Accesses outside the list are possible, but become more expensive. 

- Transactions Two Types
 - type: EIP-2718 transaction type the legacy version with v,r,s, gas, to, data, etc 
 - type: EIP-2930 which adds (accessList, chainId, yParity)

- Bloom Filters
 - probabilistic space efficient data structure
 - allows for fast checks of a set membership
 - behave inverse to caches
 - provide answer of no or maybe 
 - used with logs/events 
 - light clients can check for events in bloom filter 

- Transaction Receipt is a tuple of 
 - type of transaction
 - status code
 - gas aspects
 - set of logs 
 - Bloom filter 

- Ethereum Cryptography Curve
 - uses Ethereum uses the SECP-256k1 curve. e.g y
 - can result in signature malleability due to mirroring on curve 
 - in Ethereum signature signing often Keccak256("\x19Ethereum Signed Message:\n32") is added to start hash message
 - v is either 27 or 28 in Bitcoin and Ethereum before EIP 155, since then, the chain ID is used
 - in the calculation of v, to give protection against replaying transactions v = {0,1} + CHAIN_ID * 2 + 35