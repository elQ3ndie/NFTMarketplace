import { buildModule } from "@nomicfoundation/hardhat-ignition/modules";

const owner = "0xA32c0c266f704f1E6989e91CAE2eBCeCB4e69F22";
const name = "ZTToken"
const symbol = "ZTT"

const NFTMarketplaceModule = buildModule("NFTMarketplaceModule", (m) => {

  const marketplace = m.contract("NFTMarketplace", [owner, name, symbol]);

  return { marketplace };
});

export default NFTMarketplaceModule;