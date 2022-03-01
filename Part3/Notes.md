## Design Patterns
 - Efficiency
 - Gas 
 - Simplicity 
 - Readability
 - Most important (security)
 - Decentralisation 
 - Usability (ordering, timing, understandability, )

- Registry can be seen as an anti-pattern 
   - malicious contracts can be swapped in
- Data Contract for upgradability 
   - 
- Factory Pattern
   - create many template instances
- Incentive Execution 
   - incentivise users to call functions e.g Ethereum Alarm Clock 
- Multi-Sig Authorisation 
- State Machine
   - well known pattern in computer science
   - move between a varying number of fixed states
   - define the allowed states and define transitions between states
https://github.com/fravoll/solidity-patterns/blob/master/docs/state_machine.md 

- Role Based Access Control
- Off-chain Authorisation 
- Circut Breaker Patterns e.g pause, emergency, etc
   - pausable for time period - multisig to run this 
- Check Effects Interaction Patterns
- Pull Payments
- Oracle Patterns (publish-subscribe) (request-response) (single-read)
https://dev.to/ahmedmansoor012/ethereum-oracle-design-patterns-5api 

## Signatures 

- EIP-2612: permit – 712-signed approvals (ERC-20 approvals via secp256k1 signatures) https://eips.ethereum.org/EIPS/eip-2612 
- allows users to modify the allowance mapping using a signed message, instead of through msg.sender 
- Verifying Signature Solidity By Example => https://solidity-by-example.org/signature/ 

## Ethereum Nodes
 - Act as a Database - Contain Cryptographic Components - Network - Block Headers - Contain VM 
 - Track Ethereum Nodes -> https://etherscan.io/nodetracker 
 - Implementation explored -> Erigon 

 ## Ethereum JSON-RPC Specification

 eth_getBlockByHash => returns block info by hash
 eth_getBlockByNumber => returns block infor by number
 eth_getBlockTransactionCountByHash => returns number transactions in block by blocks hash
 eth_getProtocolVersion =>returns current ethereum protocol version
 eth_coinbase => returns client coinbase address
 eth_estimateGas => returns how much gas as estimate is allowed to enable tx to complete
 eth-sign => returns EIP 191 signature over signed data
 eth_signTransaction => returns RLP encoded transaction signed by specific account 
 eth_getCode => returns code at a given address
 eth_sendTransaction => signs and sends Transaction 
 eth_sendRawTransaction => sends raw transaction 
 eth_getTransactionByHash => returns info tx by hash of tx 

 ## EIP 1667 Minimal Proxy 
 - https://github.com/optionality/clone-factory
 - simply and cheaply clone contract functionality 
 - specifies a minimal bytecode implementation that delegates all calls to a known, fixed address
 - save on gas costs
 - clone exact contract functionality 
 - exact bytecode of the standard clone contract is this: 363d3d373d3d3d363d73bebebebebebebebebebebebebebebebebebebebe5af43d82803e903d91602b57fd5bf3
 - 

## Solidity 

 - can store data in logs, storage, memory, calldata, stack, code
 - only top 16 elements of Solidity Stack can be manipulated 
 - Memory is a byte array that expands in 32 byte chunks when more size is needed
 - Memeory is contigous so savings from packing
 - Storage (key - value pairs of 256 bits each)
 - create librares to move logic out of main contracts to cut on gas e. helper functions
 
 - Stack too deep 
    - about how many variables can be referenced in teh stack 
    - use internal function, structs, less variables to solve this
    - make use of block scoping 

- Beware to use or interpret correctly multidimnentional array e.g string[][3] with dynamic parts 

