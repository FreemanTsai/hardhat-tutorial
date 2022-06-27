# Etherscan上取得認證

使用[Etherscan](https://etherscan.io/)查看智能合約時，有些合約的Contract選項旁邊有一個綠色勾勾，可以在網頁上直接跟智能合約互動，還能看到合約的程式碼，因此能讓使用者對合約的信任度提高，畢竟原始碼都公開了嘛，搞不了小動作

這篇文章將會解說如何上傳原始碼到Etherscan並取得認證

### 方法1：使用Flatten工具再手動上傳
開發項目時，不免引用了許多套件，程式碼因此散落各處
可以使用開發工具的Flatten功能，將引用的套件原始碼擷取到同一支檔案

這邊使用Hardhat舉例，執行下列指令就可以取得flatten後的檔案了

```javascript
npx hardhat flatten contracts/MyNFT.sol > MyNFT-flatten.sol
```
但這邊有個陷阱，產出的程式碼內會含多個SPDX-License-Identifier，會導致認證失敗，需要手動移除多餘的License(實在有點麻煩)

之後到[Etherscan Verify Contract](https://etherscan.io/verifyContract)上傳原始碼，貼上合約Address依據合約內容選擇後，再把原始碼貼上，就可以往下取得認證囉！

### 方法2：透過Etherscan API
更方便的方法就是透過API囉，首先需要先到[Etherscan](https://etherscan.io/myapikey)上申請API Key

接著安裝@nomiclabs/hardhat-etherscan
```javascript
npm install @nomiclabs/hardhat-etherscan
```
添加API Key到.env內
```javascript
ETHERSCAN_API_KEY = xxxxxxxx......
```
然後調整hardhat.config.js
```javascript
require("@nomiclabs/hardhat-waffle");
require("dotenv").config();
require("@nomiclabs/hardhat-etherscan");
const { RINKEBY_URL, PRIVATE_KEY } = process.env;
module.exports = {
    solidity: "0.8.4",
    networks: {
        rinkeby: {
            url: RINKEBY_URL,
            accounts: [`0x${PRIVATE_KEY}`]
        }
    },
    etherscan: {
        apiKey: process.env.ETHERSCAN_API_KEY
    }
};
```
然後貼上要認證的contract address，執行認證
```javascript
npx hardhat verify — network rinkeby contract_address
Successfully submitted source code for contract
contracts/MyNFT.sol:MyNFT at 0xxxxxxxxx…..
for verification on the block explorer. Waiting for verification result…
Successfully verified contract MyNFT on Etherscan.
https://rinkeby.etherscan.io/address/0xxxxxxxxx.....#code
```
這樣就認證完成囉！趕快到Etherscan上看看吧！

