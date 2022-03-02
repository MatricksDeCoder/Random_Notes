Types

The type uint is equivalent with the type => uint256.
The type string is equivalent with the type => bytes array.
Internally, enum is represented as => uint (typically uint8).
What is the max value of a uint256 in decimal? In hex => 0xffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffff?
How do you compare strings? ===> How do you concat them? Compare => keccak256(bytes(a)) == keccak256(bytes(b)); Concat => string(abi.encodePacked(a, b))
What is the difference between type address and type address payable? ==> type payable can send ether using .transfer() and .send() although internally no difference. Solidity will throw error try send to non payable address 
What is the purpose of the private keyword in Solidity? ==>  to restrict variables from being accessed or modified outisde of the contract or its inherited ones; storage variables/functions inaccessible to derived contracts; however still private can be read by anyone it does not mean secret

Transactions

What are all the fields of an Ethereum transaction? ===>  (nonce, gasPrice, gasLimit, to, value, r, s,v, data) more recently its (recepient, signature, value, data, gasLimit, maxPriorityFeePerGas, maxFeePerGas )
What is msg in Solidity? What non-deprecated fields do you have access to via msg? ====> global variable allowing access to blockchain data e,g (msg.sender, msg.data, msg.sig, msg.value)
What is tx in Solidity? What fields do you have access to via tx? ===> action created by an EOA(Externally Owned Account) that follows a certain format; and can change the state of the blockchain. (tx.gasPrice, tx.origin)
What is block in Solidity? What non-deprecated fields do you have access to via block? ===> a blockchain structure that contains transactions and allows chaining with previous blocks using hashing to prevent changes to data (`block.coinbase`, `block.difficulty`, `block.gaslimit`, `block.number`, `block.timestamp`)
What persists after a transaction gets reverted? ===> Transaction persists in block and used gas transferred to minder 
When you deploy a contract, what are you sending in the data field of that transaction? ===> The contract's bytecode, including its constructor

Gas Costs
In this context, "gas cost" means amount of gas, not wei per gas.

What is the standard gas cost of a transaction? ==> 21,000
What is the gas cost of deploying a constract? ==> 32,000 21k (transaction) + 32k (CREATE opcode) + (200 * code kb size) + 1k (constructor) + storage costs
How did the recent (Aug 9th) London upgrade affect gas costs? ==> base fee introduction allows less volatility in gas prices. Fees are easier to estimate and ETH is burned every transaction https://ethereum.org/en/developers/docs/gas/#post-london 
What version of Solidity introduced automatic "safe math" operations? => 0.8.0 
What is the tradeoff of having all math operations safe? ==> gas costs so may be ideal where one knows overflow or underflow is not possible to use unchecked {} to save on gas for version 0.8.0 and above
What is the syntax for performing an unchecked math operation? ==> unchecked {...code here...}
What causes the difference in gas cost between Foo memory x = ... and Foo storage x = ...? ==> x stored in storage means its a value that persists in the blockchain so is more expensive to store and read opcodes SSTORE(can cost up to 20000 gas) SSLOAD. Whereas memory is just for the lifetime of the block/function uses MSTORE MLOAD MSTORE8 use bout 3 gas

EVM

What are the three different areas EVM programs can store data? ==> (stack, memory,storage, code)
What is the difference between assert(), revert(), and require()? What EVM opcodes do they use? ==> assert mainly used to check invariants and internal errors and it causes a PANIC error to generate error, *used to compiles to 0xfe*, which is an invalid opcode uses up all gas. Require mainly to check user inputs uses the 0xfd opcode to cause an error; condition refunds gas. Revert mainly used to handle more complex logic than require() uses opcode 0xfd,and like require() refunds gas! but `assert` communicates to the reader that the current execution should be unreachable, while `require` checks for invalid input. `revert` takes a single `string` argument and is, like `require`, used to check for bad inputs. All 3 use the `REVERT` (`0xFD`) opcode.
What is the difference between CALL, CALLCODE, and DELEGATECALL? Which one is deprecated? ===> CALLCODE is deperecated. CALL And DELEGATECALL are both low level functions however DELEGATECALL uses the context of the current contract/ caller. DELEGATECALL allows callee to modify state in current contract's context, whereas CALL is like a normal function call.
What is the syntax for writing inline assembly in Solidity? Where are the docs for this? ====> assembly {...} https://docs.soliditylang.org/en/v0.8.11/assembly.html 

Legacy Solidity
You will see plenty of old solidity contracts in the wild.

What was the original purpose of Solidity's .send() and .transfer() functions? How did it fail? ===> to limit amount of gas 2300 forwarded reduce risk of reentrancy attacks. Problem = gas costs change https://ethereum.stackexchange.com/questions/78124/is-transfer-still-safe-after-the-istanbul-update/78136#78136 
The type var is equivalent with the type  ===> now results in parse error, you need to specify the variable type it was Dynamic; Solidity infers its type based on the RHS of the assignment.
What version of Solidity introduced the receive() function definition? What was the equivalent before it? ===> 0.6.0 before this fallback() was used
What version of Solidity introduced length checking for msg.data? What manual check does this cover?  ===> 0.5.0 if the msg.data length is differnt from that defined by the signature transaction fails https://forum.openzeppelin.com/t/removing-address-0x0-checks-from-openzeppelin-contracts/2222  
What version of Solidity make checking for accidental zero addresses obsolete? ===> Solidity now validates the length of msg.data https://forum.openzeppelin.com/t/removing-address-0x0-checks-from-openzeppelin-contracts/2222 