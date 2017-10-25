pragma solidity ^0.4.11;


interface token {
    function transfer(address receiver, uint amount);
}


/**
 * @title Ownable
 * @dev The Ownable contract has an owner address, and provides basic authorization control
 * functions, this simplifies the implementation of "user permissions".
 */
contract Ownable {
  address public owner;


  event OwnershipTransferred(address indexed previousOwner, address indexed newOwner);


  /**
   * @dev The Ownable constructor sets the original `owner` of the contract to the sender
   * account.
   */
  function Ownable() {
    owner = msg.sender;
  }


  /**
   * @dev Throws if called by any account other than the owner.
   */
  modifier onlyOwner() {
    require(msg.sender == owner);
    _;
  }


  /**
   * @dev Allows the current owner to transfer control of the contract to a newOwner.
   * @param newOwner The address to transfer ownership to.
   */
  function transferOwnership(address newOwner) onlyOwner public {
    require(newOwner != address(0));
    OwnershipTransferred(owner, newOwner);
    owner = newOwner;
  }

}




//interface token {
 //   function transfer(address receiver, uint amount);
//}

contract Crowdsale is Ownable {
    address public beneficiary;
    //uint public fundingGoal;
    uint public amountRaised;

    uint public tokenPrice;
    token public tokenReward;

    mapping(address => uint256) public balanceOf;

    bool public fundingGoalReached = false;

    bool public crowdsaleEnded = false;



    event GoalReached(address beneficiary, uint amountRaised);
    event FundTransfer(address backer, uint256 amount, bool isContribution);

    /**
     * Constrctor function
     *
     * Setup the owner
     */

     modifier crowdsaleOpened() {
         require(!crowdsaleEnded);
         _;
     }

     modifier crowdsaleClosed() {
         require(crowdsaleEnded);
         _;
     }


    function Crowdsale(
        address ifSuccessfulSendTo,
       // uint fundingGoalInEthers,

        uint etherCostOfEachToken,
        address addressOfTokenUsedAsReward
    ) public {
        beneficiary = ifSuccessfulSendTo;
      //  fundingGoal = fundingGoalInEthers;

        tokenPrice = etherCostOfEachToken;
        tokenReward = token(addressOfTokenUsedAsReward);
    }


    function () payable crowdsaleOpened {
        uint amount = msg.value*10**18;
        balanceOf[msg.sender] += amount;
        amountRaised += amount;
        tokenReward.transfer(msg.sender, amount / tokenPrice);
        FundTransfer(msg.sender, amount, true);
        beneficiary.transfer(msg.value);

    }

    function priceChange(uint256 myPrice) external onlyOwner crowdsaleOpened {
        tokenPrice = myPrice;
    }

    /**
     * Check if goal was reached
     *
     * Checks if the goal or time limit has been reached and ends the campaign
     */
    function checkGoalReached() external onlyOwner crowdsaleOpened {
        // if (amountRaised >= fundingGoal){
        //     fundingGoalReached = true;
        //     GoalReached(beneficiary, amountRaised);
        // }
        crowdsaleEnded = true;
    }


   

    
}
