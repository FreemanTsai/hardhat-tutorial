# 學習開發智能合約

這個專案紀錄學習智能合約開發的過程，希望能幫助到入門的朋友。

學習重點有：
- 使用Hardhat框架
- 發行 ERC20 token
- 製作 dApp, 免費領取token
- 部署到不同的鏈, Ethereum & Avalanche


## 建立Hardhat專案
我們將使用npm安裝Hardhat，npm是Node.js預設的套件管理工具。
創建專案資料夾並安裝hardhat。
```javascript
// 創建project folder
mkdir hardhat-tutorial
cd hardhat-tutorial

//套件初始化將產生package.json
npm init --yes 
npm install --save-dev hardhat
```

創建Hardhat專案，創建時請選擇Create a basic sample project
```javascript
npx hardhat
888    888                      888 888               888
888    888                      888 888               888
888    888                      888 888               888
8888888888  8888b.  888d888 .d88888 88888b.   8888b.  888888
888    888     "88b 888P"  d88" 888 888 "88b     "88b 888
888    888 .d888888 888    888  888 888  888 .d888888 888
888    888 888  888 888    Y88b 888 888  888 888  888 Y88b.
888    888 "Y888888 888     "Y88888 888  888 "Y888888  "Y888

👷 Welcome to Hardhat v2.9.9 👷‍

? What do you want to do? …
❯ Create a basic sample project
  Create an advanced sample project
  Create an advanced sample project that uses TypeScript
  Create an empty hardhat.config.js
  Quit
```

接這會跳出三個選項，都按enter就可以了
最後一項是安裝兩個必要套件Ethers.js 及 Waffle
Ethers.js是與以太坊區塊鏈交互的SDK，Waffle是測試合約的輕量化工具
```javascript
✔ What do you want to do? · Create a basic sample project
✔ Hardhat project root: · /hardhat-tutorial
✔ Do you want to add a .gitignore? (Y/n) · y
✔ Do you want to install this sample project's dependencies with npm (@nomiclabs/hardhat-waffle ethereum-waffle chai @nomiclabs/hardhat-ethers ethers)? (Y/n) · y
```

##### Hardhat框架結構
**contracts** 智能合約的程式碼放在這，包括抽象合約
**scripts** 存放合約的部署script
**test** 自動化測試案例
**hardhat.config.js** Hardhat框架的配置

到這邊，一個Hardhat專案就建置完成了，我們開始開發智能合約吧

## 開發智能合約

智能合約中常見的標準有ERC20、ERC721、ERC1155，這邊用ERC20標準來發行Token

##### OpenZeppelin
OpenZeppelin具備各種標準的合約庫且經過安全審計，可以基於合約庫再擴充其他功能，是個安全又方便的開發工具

安裝OpenZeppelin到專案中
```javascript
npm install --save-dev @openzeppelin/contracts 
```

##### 建立ERC20合約
可以使用[OpenZeppelin Wizard](https://docs.openzeppelin.com/contracts/4.x/wizard)找到ERC20的合約範本
到資料夾contracts內，新增檔案MyToken.sol，將程式碼貼上
```javascript
//SPDX-License-Identifier: MIT
pragma solidity ^0.8.4;

import "@openzeppelin/contracts/token/ERC20/ERC20.sol";
import "@openzeppelin/contracts/token/ERC20/extensions/ERC20Burnable.sol";
import "@openzeppelin/contracts/access/Ownable.sol";

contract MyToken is ERC20, ERC20Burnable, Ownable {
    constructor() ERC20("MyToken", "MTK") {
        _mint(msg.sender, 10000000 * 10**decimals());
    }

    function mint(address to, uint256 amount) public onlyOwner {
        _mint(to, amount);
    }
}
```
如需參考OpenZeppelin原始碼可以點[這裡](https://github.com/OpenZeppelin/openzeppelin-contracts/tree/master/contracts/token/ERC20)

##### 測試合約
增加測試案例，在資料夾test中新增MyToken-test.js，貼上程式碼
```javascript
const { expect } = require("chai");
const { ethers } = require("hardhat");

describe("MyToken.sol", () => {
    let contractFactory;
    let contract;
    let owner;
    let initialSupply;

    beforeEach(async () => {
        [owner] = await ethers.getSigners();
        contractFactory = await ethers.getContractFactory("MyToken");
        contract = await contractFactory.deploy();
        initialSupply = ethers.utils.parseEther("10000000");
    });
    it("Should have correct supply", async () => {
        expect(await contract.totalSupply()).to.equal(initialSupply);
    });
    it("Owner should have all the supply", async () => {
        const ownerBalance = await contract.balanceOf(owner.address);
        expect(await contract.totalSupply()).to.equal(ownerBalance);
    });
});
```

接著運行指令`npx hardhat test test/MyToken-test.js`來執行合約測試，成功後會看到下方資訊
```javascript
  MyToken.sol
    ✔ Should have correct supply
    ✔ Owner should have all the supply

  2 passing (658ms)
```

沒有意外的話，合約就通過測試囉！準備部署合約吧！

## 部署合約

我們要將完成的合約部署到測試鏈上，測試鏈有許多選擇，而這邊選用Rinkeby
部署合約之前，我們需要先準備一些測試鏈用的ETH，以及申請一個測試節點

測試用的ETH可以使用[ChainLink](https://faucets.chain.link/)領取，只需要連結錢包就可以了，記得在狐狸錢包內選到Rinkeby網路
節點服務可以使用[Alchemy](https://www.alchemy.com/)，註冊後建立app時選擇Rinkeby網路，就可以拿到api url了
另外要再取得錢包的private key，在Metamask錢包內Account旁邊的選項內找到帳戶詳情，就可以導出private key了

在部署前，我們先用dotenv來保護敏感設定的安全，下方指令安裝dotenv
```javascript
npm install dotenv
```

在專案的根目錄下新增檔案.env，檔案內容為
```javascript
PRIVATE_KEY = YOUR_PRIVATE_KEY
RINKEBY_URL = https://.....
```

接著將hardhat.config.js更改為
```javascript
require("@nomiclabs/hardhat-waffle");
require("dotenv").config();

const { RINKEBY_URL, PRIVATE_KEY } = process.env;

module.exports = {
  solidity: "0.8.4",
  networks: {
    rinkeby: {
      url: RINKEBY_URL,
      accounts: [`0x${PRIVATE_KEY}`]
    }
  }
};
```
##### 部署script

在scripts內新增MyToken-deploy.js，並貼上程式碼
```javascript
async function main() {
    const [deployer] = await ethers.getSigners();
    const contractName = "MyToken";
    const contractFactory = await ethers.getContractFactory(contractName);
    const contract = await contractFactory.deploy();

    console.log("Contract address:", contract.address);
}

main()
    .then(() => process.exit(0))
    .catch((error) => {
        console.error(error);
        process.exit(1);
    });
```

接著就可以執行了
```javascript
npx hardhat run scripts/MyToken-deploy.js --network rinkeby  
Contract address: 0x........................   
```
合約部署完成！可以到[Rinkeby Etherscan](https://rinkeby.etherscan.io/)上查找剛剛部署的合約！
到錢包裡面，Import Token裡貼上合約地址，就可以看到我們發行的Token囉！

參考資料：
[The Complete Hands-On Hardhat Tutorialh](https://betterprogramming.pub/the-complete-hands-on-hardhat-tutorial-9e23728fc8a4)
[Hardhat官方Tutorial](https://hardhat.org/tutorial)

