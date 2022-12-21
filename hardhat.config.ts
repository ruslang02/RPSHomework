import { HardhatUserConfig } from "hardhat/config";
import "@nomicfoundation/hardhat-toolbox";

const { GOERLI_URL, GOERLI_ACCOUNT } = process.env

const config: HardhatUserConfig = {
  solidity: "0.8.17",
  networks: (() => GOERLI_ACCOUNT
    ? {
      goerli: {
        url: GOERLI_URL,
        accounts: [GOERLI_ACCOUNT],
        gas: 12000000
      }
    }
    : {}
  )()
};

export default config;
