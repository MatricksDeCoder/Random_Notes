When a users balance falls to zero remove them from the holders array 
The holders array should not contain any gap
Add events to show holders being added and removed 
Write some unit tests 
Deploy your project to a testnet 
Verify with etherscan 

for (uint i = 0; i < holders.length; i++) {
         if(holders[i] == from){
             if (balanceOf(from) == 0) {
                 holders[i] = holders[holders.length- 1];
                 holders.pop();
                }
            }