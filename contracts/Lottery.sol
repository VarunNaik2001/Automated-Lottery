//SPDX License-Identifier: MIT
// SPDX-License-Identifier: SEE LICENSE IN LICENSE
import "@chainlink/contracts/src/v0.8/VRFV2WrapperConsumerBase.sol";
pragma solidity ^0.8.0;

//solidity 

interface DaiToken  {
    function transfer(address dst, uint wad) external returns (bool);
    function balanceOf(address guy) external view returns (uint);
}

 contract LotteryCreator is VRFV2WrapperConsumerBase{

    address owner;

    DaiToken daitoken;

    uint internal ticketCount;

    mapping(address => uint) public ticketsPerAddress;
    address[] allTickets;
    bool hasTheLotteryEnded;

    //hard coded for Goerli
    address _linkTokenAddress = 0x326C977E6efc84E512bB9C30f76E30c160eD06FB;
    //harded coded for Goerli
    address _vrfV2Wrapper = 0x708701a1DfF4f478de54383E49a627eD4852C816;


    error TransferFailed();

    uint16 winner;


//0x73967c6a0904aA032C103b4104747E88c566B1A2 Dai Address Goerli Testnet
    constructor() VRFV2WrapperConsumerBase( _linkTokenAddress, _vrfV2Wrapper) {
        owner = msg.sender;
        daitoken = DaiToken(0x73967c6a0904aA032C103b4104747E88c566B1A2);
        hasTheLotteryEnded = false;
        
       
        
    }

    modifier onlyOwner {
        require(msg.sender == owner,"Only the owner can call this function");
        _;
    }

    modifier isEnded {
        require(hasTheLotteryEnded == false);
        _;
    }
    
    
    //@notice Each ticket costs 20 dai, there is a maximum of 5 tickets per address
    //@notice Each lottery is completed when 100 tickets threshold is met submitted
    function deposit(uint amountOfDai) public payable isEnded {

    
    // @notice 1. requires that 20 dai increments are sent (e.g. 20,40,60,80)
    // @notice 2. requires that each address can only submit 5 tickets
    // @noticwe 3. requires that each address holds enough dai to submit to the contract
        


        require(amountOfDai%20== 0,"Please send increments of 20 dai");

        uint tickets = amountOfDai/20;
        require(ticketsPerAddress[msg.sender] + tickets <= 5,"You can only submit a maximum of 5 tickets");

        require(daitoken.balanceOf(msg.sender)>= amountOfDai,"You do not have sufficient dai");

        bool isTransfered = daitoken.transfer(address(this), amountOfDai);

        if(!isTransfered){
            revert TransferFailed();
        }

        ticketsPerAddress[msg.sender] += tickets;

        for(uint i=0;i<tickets;i++){
            allTickets.push(msg.sender);
        }

        if(ticketCount>=100){
            endLottery();
        }

    }

    function endLottery() private{
        hasTheLotteryEnded = true;


    }

    function getTickets() public view returns(uint){
        return ticketCount;
    }


    function fulfillRandomWords(uint256 _requestId, uint256[] memory _randomWords)  internal override {
        
      }

 }
