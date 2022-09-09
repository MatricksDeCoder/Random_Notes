## Precompiled contracts
 - useful since EVM is not efficient
 - mostly for cryptographic aspects
 - tend to have addresses in lower range e.g 0x1, 0x2, 0x9 etc
 - jump out of EVM to work in client 
 - // SHA256 implemented as a native contract. 
 - tend to take form below 
 ```
 type sha256hash struct{}
// RequiredGas returns the gas required to execute the pre-compiled
contract.
//
// This method does not require any overflow checking as the input size gas
costs
// required for anything significant is so high it's impossible to pay for.
func (c *sha256hash) RequiredGas(input []byte) uint64 {
return uint64(len(input)+31)/32*params.Sha256PerWordGas +
params.Sha256BaseGas
}
func (c *sha256hash) Run(input []byte) ([]byte, error) {
h := sha256.Sum256(input)
return h[:], nil
}
 ```
- to use precompiles you must know how to call them 
- The precompile directory in ethereum’s Go client currently looks like this:
```
var PrecompiledContractsByzantium = map[common.Address]PrecompiledContract{     common.BytesToAddress([]byte{1}): &ecrecover{}, common.BytesToAddress([]byte{2}): &sha256hash{}, common.BytesToAddress([]byte{3}): &ripemd160hash{}, common.BytesToAddress([]byte{4}): &dataCopy{}, common.BytesToAddress([]byte{5}): &bigModExp{}, common.BytesToAddress([]byte{6}): &bn256Add{}, common.BytesToAddress([]byte{7}): &bn256ScalarMul{}, common.BytesToAddress([]byte{8}): &bn256Pairing{},
}
```
- e.g bigModExp resides at address 0x05
- e.g bn256Add lives at 0x06 
- bn256ScalarMul lives at 0x07, and performs k * (x, y), for k in a group with the order of the curve, and (x, y) a valid curve point as above. The inputs here are x, y, k
- calling ScalarMul below 
```
function ecmul(uint ax, uint ay, uint k) public view returns(uint[2] memory p) {
 uint[3] memory input;
 input[0] = ax;
 input[1] = ay;
 input[2] = k;

 assembly {
   if iszero(staticcall(gas, 0x07, input, 0x60, p, 0x40)) {
       revert(0,0)
   }
 }
 return p;
}
```
- pointers to memory can be initialised as let p := mload(0x40)

## Solidity User Defined Types 
- makes use of wrap and unwwrap
- https://docs.soliditylang.org/en/latest/types.html#user-defined-value-types 
- e.g // Represent a 18 decimal, 256 bit wide fixed point type using a user
defined value type.
   - type UFixed256x18 is uint256 

## Solidity function types 
- function(uint) external callback;
- then pass into functions as 
```
function query(bytes memory data, function(uint) external callback) public
{
requests.push(Request(data, callback));
emit NewRequest(requests.length - 1);
}
function reply(uint requestID, uint response) public {
// Here goes the check that the reply comes from a trusted source
requests[requestID].callback(response);
}
``` 

## Data location and assignment behaviour

- Data Location & Assignment: Data locations are not only relevant for persistence of data, but also for the semantics of assignments.

- Assignments between storage and memory (or from calldata) always create an independent copy.

- Assignments from memory to memory only create references. This means that changes to one memory variable are also visible in all other memory variables that refer to the same data.

- Assignments from storage to a local storage variable also only assign a reference.

- All other assignments to storage always copy. Examples for this case are assignments to state variables or to members of local variables of storage struct type, even if the local variable itself is just a reference.


### RANDOM NOTES-> get contract bytecode web3 ABI, Storage, Memory etc 
```
const Web3 = require("web3");
const provider = "YOUR_INFURA_OR_QUICKNODE_HTTP_ENDPOINT";
const web3 = new Web3(provider);
web3.eth.getCode(CONTRACT_ADDRESS).then(console.log);

The bytes padding varies based on the underlying Solidity types. For instance, address are zero-padded on the left side, while fixed-size bytes values less than 32 bytes (like bytes4 , bytes8 , bytes20 , etc…) are zero-padded on the right side.

abi.encode(“Solidity”)
0x0000000000000000000000000000000000000000000000000000000000000020
  0000000000000000000000000000000000000000000000000000000000000004
  536f6c6964697479000000000000000000000000000000000000000000000000

1. Offset 20 -> 32 bytes
2. String length 
3. utf-8 encoded string 

Non standard encoding 
- abi.encodePacked() 
- does not follow convetion of ABI 

Encoding contract calls
- abi.encodeWithSelector(...) abi.encodeWithSelector(bytes4 selector, ...) returns (bytes memory)
  - someContract.someFunction.selector == bytes4 selector
  - bytes4 selector === bytes4(keccak256("transfer(address,address,uint256)"));
- e.g address.call(abi.encodeWithSelector(SELECTOR, to, value));

-abi.encodeWithSignature(string memory signature, ...) returns (bytes memory)
=== 
- abi.encodeWithSelector(bytes4(keccak256(bytes(signature))), ...)

--- struct is decoded ABI as a tuple, enum as uint, contract as address etc

Solidity compiler does not allow inmplicit conversion when some information can be lost 
Explicit conversion e.g below
uint256 a = 12345;
bytes32 b = bytes32(a);

-- lower number to higher number e.g uint64 to uint128 left padding occurs 
-- higher number to lower may lose precision as higher order bits, the most on the left are discarded
uint32 a = 0x12345678;
uint16 b = uint16(a); // b = 0x5678
-- with bytes its the opposite right most bytes are discarded
bytes2 a = 0x1234;
bytes4 b = bytes4(a); // b = 0x12340000
-- explicit conversion allowed from e.g: M-bits = N-bytes from bytesM -> uintN
uint32 a = 0xcafecafe;
bytes4 b = bytes4(a); // OK
bytes4 c = 0xbeefbeef;
uint32 d = uint32(c); // OK'
M>N or M<N leads to errors 

Conversion from uint160 to address
- Implicit conversion is not allowed from uint160 to address ❌
- Explicit conversion is allowed from uint160 to address ✅

STORAGE LAYOUT CONTRACT
--solc contracts/Owner.sol --storage-layout --pretty-json 

```
