//SPDX-License-Identifier: GPL-3.0

pragma solidity ^0.8.14;

contract Memory
{
    struct Student{
        string name;
    }
    mapping (uint8 => Student) students;
    
    function get_Student () external view returns (string memory)
    {
        return students[0].name;
    }
    function change_student () external {
        //Storage waits a space that exist. The most important is the space in the memory not the value. Onli with array struct and mapping varaiables!!
        Student storage _student = students[0];
        _student.name = "Luis";
    }
}
