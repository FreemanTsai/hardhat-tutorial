# 智能合約開發 - ERC721 NFT

ERC721是Non-Fungible Token的標準，意思指發行的每個Token都是唯一的，Token有自己唯一的Id，也能為Token賦予特殊的屬性，例如性別、年齡、穿著外觀、個性特色等
[ERC721官方文件](https://ethereum.org/en/developers/docs/standards/tokens/erc-721/)

## 建立ERC721合約

我們使用OpenZeppelin的合約庫，到[Wizard](https://docs.openzeppelin.com/contracts/4.x/wizard)上選擇ERC721並勾選Mintable、Enumerable

我們再替智能合約增加幾個功能
- 設定mit price，並提供更改function
- 設定base uri，並提供更改function
- 設定發行總量，並提供mint function

到資料夾contracts內，新增檔案MyNFT.sol，將程式碼貼上
```javascript
// SPDX-License-Identifier: MIT
pragma solidity ^0.8.4;

import "@openzeppelin/contracts/token/ERC721/ERC721.sol";
import "@openzeppelin/contracts/token/ERC721/extensions/ERC721Enumerable.sol";
import "@openzeppelin/contracts/access/Ownable.sol";
import "@openzeppelin/contracts/utils/Counters.sol";

contract MyNFT is ERC721, ERC721Enumerable, Ownable {
    using Counters for Counters.Counter;
    Counters.Counter private _tokenIdCounter;

    uint256 private _maxSupply = 52;
    uint256 private _mintPrice = 0.001 * 1000000000 gwei;
    string baseURI = "ipfs://CID....../";

    constructor() ERC721("Colorful Land", "CFLA") {}

    function _baseURI() internal view virtual override returns (string memory) {
        return baseURI;
    }

    function setBaseURI(string memory newBaseURI) public onlyOwner {
        baseURI = newBaseURI;
    }

    function maxSupply() public view virtual returns (uint256) {
        return _maxSupply;
    }

    function mintPrice() public view virtual returns (uint256) {
        return _mintPrice;
    }

    function setMintPrice(uint256 newMintPrice) public onlyOwner {
        _mintPrice = newMintPrice;
    }

    function safeMint(address to) public onlyOwner {
        uint256 tokenId = _tokenIdCounter.current() + 1;
        require(tokenId <= _maxSupply, "Sold out!");
        if (tokenId <= _maxSupply) {
            _tokenIdCounter.increment();
            _safeMint(to, tokenId);
        }
    }

    function mint() public payable {
        uint256 tokenId = _tokenIdCounter.current();
        require(tokenId < _maxSupply, "Sold out!");
        require(_mintPrice <= msg.value, "ETH not enought.");
        if (tokenId <= _maxSupply) {
            _tokenIdCounter.increment();
            _mint(msg.sender, tokenId);
        }
    }

    function _beforeTokenTransfer(
        address from,
        address to,
        uint256 tokenId
    ) internal override(ERC721, ERC721Enumerable) {
        super._beforeTokenTransfer(from, to, tokenId);
    }

    function supportsInterface(bytes4 interfaceId)
        public
        view
        override(ERC721, ERC721Enumerable)
        returns (bool)
    {
        return super.supportsInterface(interfaceId);
    }
}
```

## 準備metadata & 圖片檔

NFT的屬性將會記錄在metadata中，應用端如OpenSea或支援NFT的錢包，將呼叫合約的tokenURI function，帶入TokenId取得metadata存放的位置，回傳值可以是HTTPS或IPFS的URL
metadata的內容是JSON格式，附上簡單的示例，更多細節可以參考OpenSea的[Metadata說明](https://docs.opensea.io/docs/metadata-standards)
```javascript
{
   "name": "#0001",
   "description": "#0001 of my NFT",
   "image": "ipfs://CID......./FILE_NAME.svg",
   "attributes": [
      ...
   ]
}
```

metadata中的image可以是svg/png格式，附上取得SVG的[小工具](https://www.svgviewer.dev/s/53411/red-heart)

## 部署合約
沿用[ERC20教學](/doc/ERC20_TUTORIAL.md)的部署程式，在sciprts內新增檔案MyNFT-deploy.js
```javascript
async function main() {
    const [deployer] = await ethers.getSigners();
    const contractName = "MyNFT";
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

接著部署合約
```javascript
npx hardhat run scripts/MyNFT-deploy.js --network rinkeby  
Contract address: 0x........................   
```
合約部署後，接著認證合約，這樣可以透過Etherscan直接跟合約互動，方便測試，如何認證合約請參考[在Etherscan上取得認證](/doc/VERIFY_CONTRACT.md)

```javascript
npx hardhat verify --network rinkeby 0x........................
```
有時認證失敗，是因為合約還沒部署完成唷，稍等一下再試試

## 與合約互動

合約部署&認證完成了！趕快到[Rinkeby Etherscan](https://rinkeby.etherscan.io/)上mint第一個NFT吧！
搜尋到contract後，點選Contract -> Write Contract -> safeMint，填入想要派送的錢包位置，就能夠發送NFT囉！
發送後稍等幾分鐘，就可以到到[OpenSea](https://testnets.opensea.io/)上或是錢包內，看看NFT有沒有出現
![](/image/NFT_WALLET.jpg)

*小提醒：Rinkeby測試網有時挺卡的，圖片有時候也出不來，需要多點耐心～

到這邊，第一個NFT就已經完成囉！
也可以試試看mint function，這是需要支付費用mint的唷！