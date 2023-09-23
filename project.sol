/**
Question

Forge a user registration and authentication system tailored
for both renters and disk space providers. This system will 
ensure secure and seamless access to the platform?
*/

// SPDX-License-Identifier: MIT
pragma solidity ^0.8.0;

contract UserRegistration {
    constructor() {
        owner = msg.sender;
    }

    enum UserRole {
        Renter,
        Provider
    }

    address public owner;

    //user struct
    struct User {
        string username;
        string email;
        string password;
        UserRole role;
        bool isRegistered;
    }

    mapping(address => User) public users;
    address[] public registeredUsers;

    event UserRegistered(
        address indexed userAddress,
        string username,
        UserRole role
    );

    //owner modifier
    modifier onlyOwner() {
        require(msg.sender == owner, "invalid Owner");
        _;
    }

    //This fuction will register the user and its role
    function registerUser(
        string memory _username,
        string memory _email,
        string memory _password,
        UserRole _role
    ) public onlyOwner {
        // if user is already register then we revert it.
        require(!users[msg.sender].isRegistered, "User already registered.");

        //store the user in mapping
        User memory newUser = User(_username, _email, _password, _role, true);
        users[msg.sender] = newUser;

        //push the user into array
        registeredUsers.push(msg.sender);
        emit UserRegistered(msg.sender, _username, _role);
    }

    //change the role to renter and provider
    //but this fuction will be called only valid owner
    function changeRole() public onlyOwner{
        if (users[msg.sender].role == UserRole.Provider) {
            users[msg.sender].role = UserRole.Renter;
        } else {
            users[msg.sender].role = UserRole.Provider;
        }
    }


    //authenticate the users based on username and passward
    function authenticateUser(string memory _username, string memory _password)
        public
        view
        returns (
            string memory,
            UserRole,
            string memory
        )
    {
        User memory user = users[msg.sender];
        if (
            user.isRegistered &&
            keccak256(bytes(user.username)) == keccak256(bytes(_username)) &&
            keccak256(bytes(user.password)) == keccak256(bytes(_password))
        ) {
            return ("authentic user", user.role, "the user role is Provider"); // Returns the user's role if authentication is successful
        }
        return ("Unauthorize user", UserRole.Renter, "the user role is Renter"); // Default role when authentication fails
    }
}
