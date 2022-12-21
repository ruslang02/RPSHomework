import { HardhatUserConfig } from "hardhat/config";
import "@nomicfoundation/hardhat-toolbox";

const { GOERLI_URL, GOERLI_ACCOUNT } = process.env

const config: HardhatUserConfig = {
  solidity: "0.8.17",
  networks: (() => GOERLI_ACCOUNT
    ? {
      goerli: {
        url: GOERLI_URL,
        accounts: [GOERLI_ACCOUNT]
      }
    }
    : {}
  )()
};

export default config;
