// SPDX-License-Identifier: MIT
pragma solidity ^0.8.19;

contract CryptoTips {
    
    struct Tip {
        address from;      // Кто отправил
        uint amount;       // Сколько ETH (в wei)
        string message;    // Сообщение
        uint timestamp;    // Когда
    }
    
    Tip[] public tips;
    
    event NewTip(address indexed from, uint amount, string message);
    
    // Отправить чаевые с сообщением
    function sendTip(string memory _message) public payable {
        require(msg.value > 0, "Send some ETH!");
        require(bytes(_message).length > 0, "Add a message!");
        require(bytes(_message).length <= 280, "Message too long!");
        
        tips.push(Tip({
            from: msg.sender,
            amount: msg.value,
            message: _message,
            timestamp: block.timestamp
        }));
        
        emit NewTip(msg.sender, msg.value, _message);
    }
    
    // Получить все чаевые
    function getAllTips() public view returns (Tip[] memory) {
        return tips;
    }
    
    // Получить количество чаевых
    function getTipsCount() public view returns (uint) {
        return tips.length;
    }
    
    // Вывести средства (только владелец контракта)
    address public owner;
    
    constructor() {
        owner = msg.sender;
    }
    
    function withdraw() public {
        require(msg.sender == owner, "Only owner!");
        payable(owner).transfer(address(this).balance);
    }
    
    // Проверить баланс контракта
    function getBalance() public view returns (uint) {
        return address(this).balance;
    }
}