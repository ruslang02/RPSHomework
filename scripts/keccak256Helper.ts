import {ethers} from "ethers";

const address = "<address>";
const gameIndex = 0;
const gameChoice = [0, 1, 2, 3];
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