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
    string private baseURI =
        "ipfs://QmZtM5QgYfB76KZiGxt1H8upa3oG8W7goPucT4abravyVg/";

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
        uint256 tokenId = _tokenIdCounter.current();
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
