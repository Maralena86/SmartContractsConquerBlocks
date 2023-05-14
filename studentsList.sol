//SPDX-License-Identifier: GPL-3.0

pragma solidity >=0.7.0 <0.9.0;
contract StudentList{
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

    function addStudent(string memory _name, string memory _lastname, uint8 _age) public 
    {
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
}