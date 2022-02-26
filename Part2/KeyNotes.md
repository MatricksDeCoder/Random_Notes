## Notes and Key Points 

## ABIs 

- there is no solidity onchain only EVM bytecode 

- Application Binary Interface used for 
   => transaction date
   => contract to another contract function calls
   => front end applications 
- you must know how to encode your binary when sending data to other contracts 

## Function calls 
 = e.g 


### Contract-to-contract function calls

Solidity uint result = target.foo(10); === (bool success, bytes memory returnData)
      = target.call(abi.encodeWithSignature('foo(uint256)', [10]));

### JavaScript Example

JSON ABI artifacts

    await contract.sign("Hello")

vs

    await sendTransaction({
      from: player,
      to: instance,
      data: web3.eth.abi.encodeFunctionCall({
        name: 'sign',
        type: 'function',
        inputs: [
          { type: 'string', name: 'message' }
        ]
      }, [
        "Hello"
      ])
    })


## ABI encoding functions 
- abi.encode(...) returns (bytes)
- abi.encodePacked(...) returns (bytes) 
- abi.encodeWithSelector(bytes4 selector, ...) returns (bytes) =>  encodes from second argument and prepends the 4 byte selector
- abi.encodeWithSignature(string signature, ...) returns (bytes) === abi.encodeWithSelector(bytes4(keccak256(signature), ...)

- abi.encode("AAAA") == 0x0000000000000000000000000000000000000000000000000000000000000020
0x0000000000000000000000000000000000000000000000000000000000000004
0x4141414100000000000000000000000000000000000000000000000000000000

   - The above 96bytes are 3 words which can be broken down into the following: (have padding to ensure )
     (a) starting offset of first parameter 
     (b) the length of the string 
     (c) data UTF-8 encoded with paddign 32 bytes

- abi.encode("AAAA", "BBBB"); === 0x0000000000000000000000000000000000000000000000000000000000000040
0x0000000000000000000000000000000000000000000000000000000000000080
0x0000000000000000000000000000000000000000000000000000000000000004
0x4141414100000000000000000000000000000000000000000000000000000000
0x0000000000000000000000000000000000000000000000000000000000000004
0x4242424200000000000000000000000000000000000000000000000000000000

   (a) starting offset first parameter offset
   (b) second parameter offset
   (c) lenght first parameter
   (d) utf-8 encoded padded value of "AAAA"
   (e) lenght of second parameter 
   (f) last of the 6 words ===> utf-8 encoded padded value of "BBBB"

- uint8[3] memory arr = [0x1, 0x2, 0x42];
abi.encode(arr, "AAAA", "BBBB");  === 0x0000000000000000000000000000000000000000000000000000000000000001
0x0000000000000000000000000000000000000000000000000000000000000002
0x0000000000000000000000000000000000000000000000000000000000000042
0x00000000000000000000000000000000000000000000000000000000000000a0
0x00000000000000000000000000000000000000000000000000000000000000e0
0x0000000000000000000000000000000000000000000000000000000000000004
0x4141414100000000000000000000000000000000000000000000000000000000
0x0000000000000000000000000000000000000000000000000000000000000004
0x4242424200000000000000000000000000000000000000000000000000000000

    - rules fixed length array will lay values direct 
    (a) first array valye
    (b) second array value
    (c) third array value
    (d) offset for start of second parameter "AAAA" at 160 in decimal meaning start of 6th word
    (e) offset for start of the third parameter "BBBB" 224 in decimal meaning start of 8th word
    (f) length "AAAA"
    (g) utf-8 encoded padded value of "AAAA"
    (h) length "BBBB"
    (i) last of the 9 words ===> utf-8 encoded padded value of "BBBB"

- abi.encodePacked("AAAA"); === 0x41414141
- abi.encodePacked(uint8(0x42), uint256(0x1337), "AAAA", "BBBB") === 0x42
0x0000000000000000000000000000000000000000000000000000000000001337
0x41414141
0x42424242

 - Bytecode: 0x60106020...  === - Assembly: PUSH1 0x10 PUSH1 0x20
   - each byte represents an OpCode 

- calling function getEntries() === ethers.utils.keccak256(ethers.utils.toUtf8Bytes('getEntries()')) === Calldata: 0x17be85c3

if (functionSelector === '0x17be85c3') {
  // Run code for getEntries()
}
else if (functionSelector === '0x79d6348d') {
  // Run code for sign(string)
}
else if (functionSelector === '0x79d6348d') {
  // Run code for sign(string)
}
else {
  // If fallback defined, run it
  // Else, revert
}

someContract.setGreeting(true, "abc", 1)

0x
71a6155e - function selector
0000000000000000000000000000000000000000000000000000000000000001 - bool
0000000000000000000000000000000000000000000000000000000000000060 - string (offset)
0000000000000000000000000000000000000000000000000000000000000001 - uint256 1
0000000000000000000000000000000000000000000000000000000000000003 - string length
6162630000000000000000000000000000000000000000000000000000000000 - string data

### EVM OPCodes + Gas + Various Factors and workings

