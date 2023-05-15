//SPDX-License-Identifier: GPL-3.0

pragma solidity >=0.7.0 <0.9.0;
contract StudentList{
    address private owner;
    struct Student{
        string name;
        string lastName;
        uint8 age;
        bool exist;

    }
    uint32 numStudent;
    mapping (address => Student) students;
   
    Student [] studentsInfo;

    address [] studentAddress;
    constructor()
    {
        owner = msg.sender;
    }

    function addStudent(string memory _name, string memory _lastname, uint8 _age) public 
    {
        //Require is for make conditions that are essentials for the contract
        require(bytes(_name).length != 0, "Error: name is empty");
        require(bytes(_lastname).length != 0, "Error: lastname is empty");
        require(_age > 8, "Error: you're not bigger than 8");
        if(!students[msg.sender].exist){

            studentAddress.push(msg.sender);
            students[msg.sender] = Student(_name, _lastname, _age, true);
            studentsInfo.push(students[msg.sender]);
            numStudent++;   
        }
    }
    function getStudentByAddress() public view returns(Student memory)
    {
        return students[msg.sender];
    }
    function getAllStudents() public view returns(Student [] memory) 
    {
        return studentsInfo;
    }
    //Modifier helps to change a comportment easily and faster
    modifier onlyOwner ()
    {
        require(msg.sender == owner);
        _;
    }
}