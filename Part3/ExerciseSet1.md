Types

The type uint is equivalent with the type => uint256.
The type string is equivalent with the type => bytes array.
Internally, enum is represented as => uint (typically uint8).
What is the max value of a uint256 in decimal? In hex => 0xffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffff?
How do you compare strings? ===> How do you concat them? Compare => keccak256(bytes(a)) == keccak256(bytes(b)); Concat => string(abi.encodePacked(a, b))
What is the difference between type address and type address payable? ==> type payable can ether using .transfer() and .send()
What is the purpose of the private keyword in Solidity? ==>  to restrict variables from being accessed or modified outisde of the contract or its inherited ones; however still private can be read by anyone it does not mean secret

Transactions

What are all the fields of an Ethereum transaction? ===>  (nonce, gasPrice, gasLimit, to, value, r, s,v, data) more recently its (recepient, signature, value, data, gasLimit, maxPriorityFeePerGas, maxFeePerGas )
What is msg in Solidity? What non-deprecated fields do you have access to via msg? ====> global variable allowing access to blockchain data e,g (msg.sender, msg.data, msg.sig, msg.value)
What is tx in Solidity? What fields do you have access to via tx? ===> action created by an EOA(Externally Owned Account) that follows a certain format; and can change the state of the blockchain. Fields same as in first answer above!
What is block in Solidity? What non-deprecated fields do you have access to via block? ===> a blockchain structure that contains transactions and allows chaining with previous blocks using hashing to prevent changes to data 
What persists after a transaction gets reverted? ===> 
When you deploy a contract, what are you sending in the data field of that transaction? ===> state changes are reverted so nothing persists on state; however the nonce persists and cant be reused for next transaction; needs to be incremented

Gas Costs
In this context, "gas cost" means amount of gas, not wei per gas.

What is the standard gas cost of a transaction? ==> 21,000
What is the gas cost of deploying a constract? ==> 32,000
How did the recent (Aug 9th) London upgrade affect gas costs? ==> base fee introduction allows less volatility in gas prices 
What version of Solidity introduced automatic "safe math" operations? => 0.8.0 
What is the tradeoff of having all math operations safe? ==> gas costs so may be ideal where one knows overflow or underflow is not possible to use unchecked {} to save on gas for version 0.8.0 and above
What is the syntax for performing an unchecked math operation? ==> unchecked {...code here...}
What causes the difference in gas cost between Foo memory x = ... and Foo storage x = ...? ==> x stored in storage means its a value that persists in the blockchain so is more expensive to store and read opcodes SSTORE(can cost up to 20000 gas) SSLOAD. Whereas memory is just for the lifetime of the block/function uses MSTORE MLOAD MSTORE8 use bout 3 gas

EVM

What are the three different areas EVM programs can store data? ==> (code, memory,storage)
What is the difference between assert(), revert(), and require()? What EVM opcodes do they use? ==> assert mainly used to check invariants and internal errors and it causes a PANIC error to generate error, t compiles to 0xfe, which is an invalid opcode uses up all gas. Require mainly to check user inputs uses the 0xfd opcode to cause an error; condition refunds gas. Revert mainly used to handle more complex logic than require() uses opcode 0xfd,and like require() refunds gas 
What is the difference between CALL, CALLCODE, and DELEGATECALL? Which one is deprecated? ===> CALLCODE is deperecated. CALL And DELEGATECALL are both low level functions however DELEGATECALL uses the context of the current contract/ caller
What is the syntax for writing inline assembly in Solidity? Where are the docs for this? ====> assembly {...} https://docs.soliditylang.org/en/v0.8.11/assembly.html 

Legacy Solidity
You will see plenty of old solidity contracts in the wild.

What was the original purpose of Solidity's .send() and .transfer() functions? How did it fail? ===> to limit amount of gas 2300 forwarded reduce risk of reentrancy attacks. Problem = gas costs change
The type var is equivalent with the type  ===> now results in parse error, you need to specify the variable type 
What version of Solidity introduced the receive() function definition? What was the equivalent before it? ===> 0.6.0 before this fallback() was used
What version of Solidity introduced length checking for msg.data? What manual check does this cover?  ===> 0.5.0 if the msg.data length is differnt from that defined by the signature transaction fails
What version of Solidity make checking for accidental zero addresses obsolete? ===> Not sure 