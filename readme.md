<h3 style="line-height:30px; color: yellow">Forge a user registration and authentication system tailored
for both renters and disk space providers. This system will 
ensure secure and seamless access to the platform?</h3>

<hr>

### Datatype used

1. Enum <code>UserRole</code>
   - We have a Enum datatype which will set the role of user.
   ```sol
   enum UserRole {
       Renter,
       Provider
   }
   ```
2. address <code>owner</code>
   - There have a address which store owner address based on this we can restrict the unathurize user.
   ```sol
    address public owner;
   ```
3. Struct <code>User</code>
   - we have define a struct which is our user-define datatype, and this will store information related to the User,either he is renter or provider.
   ```sol
    struct User {
        string username;
        string email;
        string password;
        UserRole role;
        bool isRegistered;
    }
   ```
4. mapping <code>users</code>
   - we can store all the data users in this mapping based on his unique address
   ```sol
     mapping(address => User) public users;
   ```
5. address <code>registeredUsers</code>
   - we can store all the users addresses
   ```sol
     address[] public registeredUsers;
   ```
6. Event <code>UserRegistered</code>
   - when we store the user info so we can emit this event, to display the record in logs menu
   ```sol
     event UserRegistered(
        address indexed userAddress,
        string username,
        UserRole role
    );
   ```
7. modifier <code>onlyOwner</code>
   - we will set restrict other user to minupulate this contract only the valid owner will interect to this contract
   ```sol
    modifier onlyOwner() {
        require(msg.sender == owner, "invalid Owner");
        _;
    }
   ```
8. function <code>registerUser</code>

   - This fuction will register the user and its role.
   - takes 4 arguments
     - \_username
     - \_password
     - \_email
     - \_role
   - we can apply modifier here only owner will register the users.
   <h4 style="padding-left:25px;color: yellow">working procedure:</h4>

   - if user is register then we revert it
   - store the user in mapping
   - push the user address in the array

   ```sol
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
   ```

9. function <code>changeRole</code>

   - This fuction will change the role of the user,is it renter or provider.
   - the visibility is public.
   - we can apply modifier here only owner will register the users.
   <h4 style="padding-left:25px;color: yellow">working procedure:</h4>

   - if user role is renter then we set it into provider.
   - it user role is provider we can ser it into renter.

   ```sol
   function changeRole() public onlyOwner{
        if (users[msg.sender].role == UserRole.Provider) {
            users[msg.sender].role = UserRole.Renter;
        } else {
            users[msg.sender].role = UserRole.Provider;
        }
    }

   ```

10. function <code>authenticateUser</code>

    - This fuction will authenticate the user is it a vilid user or not.Is the pasward which they provide is matched the password store in databas or not
    - the visibility is public.
    - takes 4 arguments
      - \_username
      - \_password
    - we can return the bool value.if user is valid the return value is true else false
    <h4 style="padding-left:25px;color: yellow">working procedure:</h4>

    - fisrt we can find the user by calling the mapping used msg.sender
    - then we check, the user is register or not by checking the struct isRegistered bool value.
    - then we can check its username and password by using <code>keccak256(bytes(username)) && keccak256(bytes(username))</code>

    ```sol

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

    ```
