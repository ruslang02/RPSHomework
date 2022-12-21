# RPSHomework

Rock, Paper and Scissors game smart contract

Supports multiple games simultaneuosly.

Deployed on: https://mumbai.polygonscan.com/address/0x59F968a917b5eE54012cCc0A27091E8E7a297406#code

## Why commit-reveal?

It allows for the users of the smart contract to commit a certain value to the blockchain without actually revealing it to other participants by storing its hash. Later, the user can confirm the data they sent is valid by providing the data and salt that was used to generate a hash.

To deploy on Goerli network, run:

```shell
GOERLI_URL=https://goerli.infura.io/v3/... GOERLI_ACCOUNT=0xfd3... npx hardhat run scripts/deploy.ts --network goerli
```
