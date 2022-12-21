import {ethers} from "ethers";

// const address = "0x9d88CD36D2f1344A32A026C916A011bF8781cE9B";
const address = "0x836ab4346e828B40620a5DE954337cBfC8CB4Ff8";
const gameIndex = 0;
// const gameChoice = 1;
const gameChoice = 2;
const salt = ethers.utils.randomBytes(32);

console.log("salt", Buffer.from(salt).toString('hex'))

const keccak = ethers.utils.keccak256(
    ethers.utils.solidityPack(
        ["address", "uint256", "uint", "bytes32"],
        [
            address,
            gameIndex,
            gameChoice,
            salt
        ]
    )
)

console.log("keccak", keccak);