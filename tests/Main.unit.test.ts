import { type SignerWithAddress } from "@nomiclabs/hardhat-ethers/signers";
import { type Main } from "_typechain/Main";
import { ethers } from "hardhat";
import {
  beforeEachFacade,
  expect,
  testAccounts,
} from "_services/test.service";

const CONTRACT_NAME = "Main";

describe(CONTRACT_NAME, () => {
  testAccounts.forEach(({ index, name, address, describeMessage }) => {
    let instance: Main;
    let signer: SignerWithAddress;

    describe(describeMessage, () => {
      beforeEach(async () => {
        const common = await beforeEachFacade<Main>(CONTRACT_NAME, [], index);
        instance = common.signerInstance;
        signer = common.signer;
      });

      describe("constructor", () => {
        it("runs without reverting", async () => {
          expect(true).to.equal(true);
        });
      });
    });
  });
});
