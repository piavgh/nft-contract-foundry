// SPDX-License-Identifier: MIT
pragma solidity ^0.8.4;

import "@openzeppelin/contracts/token/ERC721/ERC721.sol";
import "@openzeppelin/contracts/token/ERC721/extensions/ERC721Enumerable.sol";
import "@openzeppelin/contracts/token/ERC721/extensions/ERC721URIStorage.sol";
import "@openzeppelin/contracts/access/Ownable.sol";
import "@openzeppelin/contracts/utils/Counters.sol";

contract HoangNFT is ERC721, ERC721Enumerable, ERC721URIStorage, Ownable {
    using Counters for Counters.Counter;

    Counters.Counter private _tokenIdCounter;
    uint256 public MAX_SUPPLY = 10000;
    uint8 public MAX_TOKEN_PER_WALLET = 2;
    mapping(address => uint8) private _walletToTokenCount;

    constructor() ERC721("HoangNFT", "HNFT") {}

    function safeMint(address to, string memory uri) public {
        require(
            _tokenIdCounter.current() <= MAX_SUPPLY,
            "Sorry we reached the cap"
        );
        require(
            _walletToTokenCount[msg.sender] < MAX_TOKEN_PER_WALLET,
            "You have reached the limit"
        );
        uint256 tokenId = _tokenIdCounter.current();
        _walletToTokenCount[msg.sender]++;
        _tokenIdCounter.increment();
        _safeMint(to, tokenId);
        _setTokenURI(tokenId, uri);
    }

    function setMaxTokenPerWallet(uint8 maxTokenPerWallet) public onlyOwner {
        MAX_TOKEN_PER_WALLET = maxTokenPerWallet;
    }

    // The following functions are overrides required by Solidity.

    function _beforeTokenTransfer(
        address from,
        address to,
        uint256 tokenId
    ) internal override(ERC721, ERC721Enumerable) {
        super._beforeTokenTransfer(from, to, tokenId);
    }

    function _burn(uint256 tokenId)
        internal
        override(ERC721, ERC721URIStorage)
    {
        super._burn(tokenId);
    }

    function tokenURI(uint256 tokenId)
        public
        view
        override(ERC721, ERC721URIStorage)
        returns (string memory)
    {
        return super.tokenURI(tokenId);
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
