// SPDX-License-Identifier: UNLICENSED
pragma solidity ^0.8.0;

contract Subscriptions {
    address payable public owner;
    enum Tiers{
        None,
        Tier1,
        Tier2, 
        Tier3
    }
    /**
     * @dev Mapping of addresses to their subscription tier
     */
    struct Subscription{
        Tiers tier;
        uint256 expiration;
        string subsribedTo;
    }

    // struct for User (username_identifier)
    struct User{
        string username_identifier;
        address payable owner;
        uint256 balance;
    }

    //map an address to an array of Subscription
    mapping(address => Subscription[]) public subscriptions;


    mapping(string => User) public users;

    //function to add to the username_identifiers array (only the owner can add)
    function addCreator(string memory _username, address payable _address) public {
        require(msg.sender == owner, "Only the contract owner can add creators");
        users[_username] = User(_username, _address, 0);
    }

    function addCreator(string memory _username) public {
        require(msg.sender == owner, "Only the contract owner can add creators");
        users[_username] = User(_username, payable(address(0)), 0);
    }


    //function to change the owner of a username_identifier (only the owner can change)
    function changeOwner(string memory _username, address payable _newOwner) public {
        require(msg.sender == owner, "Only the contract owner can change owners");
        require(users[_username].owner != address(0), "Username does not exist");
        users[_username].owner = payable(_newOwner);
    }

    //function to check if a username_identifier is valid
    function checkUsername(string memory _username) public view returns(bool){
        if(users[_username].owner != address(0)){
            return true;
        }
        return false;
        
    }

   
     //function to subscribeto tier3 to a username_identifier
    function subscribeToTier3(string memory _username) public payable {
        require(msg.value == 0.01 ether, "Incorrect ether amount for Tier 3");
        //check if username_identifier is valid
        require(checkUsername(_username), "Username does not exist");
        //check if user is already subscribed to this username_identifier
        for(uint i = 0; i < subscriptions[msg.sender].length; i++){
            if(keccak256(abi.encodePacked(subscriptions[msg.sender][i].subsribedTo)) == keccak256(abi.encodePacked(_username))){
                require(subscriptions[msg.sender][i].tier != Tiers.Tier3 && subscriptions[msg.sender][i].expiration > block.timestamp, "Already subscribed as Tier 3 to this username_identifier");
                //remove current subsription 
                delete subscriptions[msg.sender][i];
                //end loop
                break;
            }
        }
        //add subscription to user
        subscriptions[msg.sender].push(Subscription(Tiers.Tier3, block.timestamp + 30 days, _username));

        // add to balance
        users[_username].balance += msg.value;
    }

    //function to subscribeto tier2 to a username_identifier
    function subscribeToTier2(string memory _username) public payable {
        require(msg.value == 0.005 ether, "Incorrect ether amount for Tier 2");
        //check if username_identifier is valid
        require(checkUsername(_username), "Username does not exist");
        //check if user is already subscribed to this username_identifier
        for(uint i = 0; i < subscriptions[msg.sender].length; i++){
            if(keccak256(abi.encodePacked(subscriptions[msg.sender][i].subsribedTo)) == keccak256(abi.encodePacked(_username))){
                require(subscriptions[msg.sender][i].tier != Tiers.Tier2 && subscriptions[msg.sender][i].expiration > block.timestamp, "Already subscribed as Tier 2 to this username_identifier");
                //remove current subsription 
                delete subscriptions[msg.sender][i];
                //end loop
                break;
            }
        }
        //add subscription to user
        subscriptions[msg.sender].push(Subscription(Tiers.Tier2, block.timestamp + 30 days, _username));

        // add to balance
        users[_username].balance += msg.value;
    }

    //function to subscribeto tier1 to a username_identifier
    function subscribeToTier1(string memory _username) public payable {
        require(msg.value == 0.001 ether, "Incorrect ether amount for Tier 1");
        //check if username_identifier is valid
        require(checkUsername(_username), "Username does not exist");
        //check if user is already subscribed to this username_identifier
        for(uint i = 0; i < subscriptions[msg.sender].length; i++){
            if(keccak256(abi.encodePacked(subscriptions[msg.sender][i].subsribedTo)) == keccak256(abi.encodePacked(_username))){
                require(subscriptions[msg.sender][i].tier != Tiers.Tier1 && subscriptions[msg.sender][i].expiration > block.timestamp, "Already subscribed as Tier 1 to this username_identifier");
                //remove current subsription 
                delete subscriptions[msg.sender][i];
                //end loop
                break;
            }
        }
        //add subscription to user
        subscriptions[msg.sender].push(Subscription(Tiers.Tier1, block.timestamp + 30 days, _username));

        // add to balance
        users[_username].balance += msg.value;
    }



    
    //function to check if a user is subscribed to a username_identifier
    function checkSubscription(string memory _username) public view returns(bool){
        for(uint i = 0; i < subscriptions[msg.sender].length; i++){
            if(keccak256(abi.encodePacked(subscriptions[msg.sender][i].subsribedTo)) == keccak256(abi.encodePacked(_username))){
                if(subscriptions[msg.sender][i].expiration > block.timestamp){
                    return true;
                }
            }
        }
        return false;
    }

    //function to check balance of a username_identifier
    function checkBalance(string memory _username) public view returns(uint256){
        require(checkUsername(_username), "Username does not exist");
        return users[_username].balance;
    }

    //function to withdraw balance of a username_identifier
    function withdrawBalance(string memory _username) public {
        require(checkUsername(_username), "Username does not exist");
        require(users[_username].owner == msg.sender, "Only the owner of the username_identifier can withdraw the balance");
        bool paid = payable(msg.sender).send(users[_username].balance);
        require(paid, "Failed to withdraw balance");
        users[_username].balance = 0;
    }

    //function to check tier of a user's subscription to a username_identifier
    function checkTier(string memory _username) public view returns(Tiers){
        for(uint i = 0; i < subscriptions[msg.sender].length; i++){
            if(keccak256(abi.encodePacked(subscriptions[msg.sender][i].subsribedTo)) == keccak256(abi.encodePacked(_username))){
                if(subscriptions[msg.sender][i].expiration > block.timestamp){
                    return subscriptions[msg.sender][i].tier;
                }
            }
        }
        return Tiers.None;
    }

    //function to check expiration of a user's subscription to a username_identifier
    function checkExpiration(string memory _username) public view returns(uint256){
        for(uint i = 0; i < subscriptions[msg.sender].length; i++){
            if(keccak256(abi.encodePacked(subscriptions[msg.sender][i].subsribedTo)) == keccak256(abi.encodePacked(_username))){
                if(subscriptions[msg.sender][i].expiration > block.timestamp){
                    return subscriptions[msg.sender][i].expiration;
                }
            }
        }
        return 0;
    }




    constructor() {
        owner = payable(msg.sender);
    }
}
