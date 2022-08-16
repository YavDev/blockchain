// SPDX-License-Identifier: UNLICENSED
pragma solidity ^0.8.0;
pragma abicoder v2;
import "./Ownable.sol";


contract TechnoLimeStore is Ownable{
    event ProductAdded(string productId, string productName, uint quantity, bool isAvailable);
    event ProductQuantityUpdated(string productId, string productName, uint quantity);
    event BoughtProduct(string productId, string productName, address buyer);
    
    struct Product {
        string productId;
        string productName;
        uint quantity;
        bool isAvailable;
    }

    struct BoughtProducts {
        string productId;
        string productName;
        uint quantity;
        uint256 timestamp;
    }
    
    mapping(string => Product) public products;

    Product[] public allProducts;

    mapping(string => mapping(address => BoughtProducts)) boughtProducts;


    function addProduct(string memory _productId, string memory _productName, uint _quantity) public onlyOwner {
        require(!products[_productId].isAvailable, "The Product already exist");

        Product memory product = Product(_productId, _productName, _quantity, true);
		
        products[_productId] = product;
        allProducts.push(product);

        emit ProductAdded(product.productId, product.productName, product.quantity, product.isAvailable);
    }

    function updateQuantity(string memory _productId, uint _quantity) public onlyOwner {
        Product memory product = products[_productId];
        require(product.isAvailable, "The Product does not exist");
        require(product.quantity != _quantity, "The quantitiy is the same as in the store, please add the new quantity");

        products[_productId].quantity = _quantity;
        Product memory updatedProduct = products[_productId];

        emit ProductQuantityUpdated(updatedProduct.productId, updatedProduct.productName, updatedProduct.quantity);
    }

    function showAllProducts() public view returns (Product[] memory) {
        return allProducts;
    }

    function buyProduct(string memory _productId) public {
        Product memory product = products[_productId];
        address currentUser = msg.sender;
        require(currentUser != owner, "To buy products, Log in as a client");
        require(product.isAvailable, "The Product does not exist");
        require(product.quantity > 0, "The product is out of stock" );
        require(boughtProducts[_productId][currentUser].quantity == 0, "You have already bought this product, each client can buy olny one unit of each product");

        BoughtProducts memory boughtProduct = boughtProducts[_productId][currentUser];
        boughtProduct.productId = _productId;
        boughtProduct.productName = product.productName;
        boughtProduct.quantity = 1;
        boughtProduct.timestamp = block.timestamp;

        boughtProducts[_productId][currentUser] = boughtProduct;
        products[_productId].quantity--;

        emit BoughtProduct(boughtProduct.productId, boughtProduct.productName, currentUser);
    }
}