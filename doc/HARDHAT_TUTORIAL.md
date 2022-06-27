# 智能合約開發 - Hardhat環境設置

Hardhat是一個方便在以太坊上開發應用的工具，它能幫助管理、測試、部署合約，且內置開發用的以太坊網路，讓開發過程輕鬆不少

### 安裝Node.js
Hardhat依賴於Node.js，如有需要可以到[nodejs.org](https://nodejs.org/en/)下載安裝
```javascript
//查看環境下的Node.js
node -v           
v16.15.1
```

### 安裝Hardhat
我們將使用npm安裝Hardhat，npm是Node.js預設的套件管理工具  
創建專案資料夾並安裝hardhat
```javascript
// 創建project folder
mkdir hardhat-tutorial
cd hardhat-tutorial

//套件初始化將產生package.json
npm init --yes 
npm install --save-dev hardhat
```

### 建立Hardhat專案
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

### Hardhat框架結構
**contracts** 智能合約的程式碼放在這，包括抽象合約  
**scripts** 部署合約的script  
**test** 自動化測試案例  
**hardhat.config.js** Hardhat框架的配置  

到這邊，一個Hardhat專案就建置完成了，我們開始開發智能合約吧
