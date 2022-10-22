'use strict'

var problems = {
    169 : {
        name : "Moore Voting Algorithm",
        description : "Counts most frequently occuring element in an array. Only condition is that that this element should occur atleast n/2 times where n is size of array",
        platform : "LeetCode"
    }
};

var num = prompt("Give the problem number >>>");
var obj = problems[num];

if(obj != undefined){
    document.querySelector('h1').textContent = obj.name;
    document.querySelector('h3').textContent = obj.description;
    document.querySelector('body').style.backgroundColor = 'yellow';
}else{
    document.querySelector('h1').textContent = "ERROR";
    document.querySelector('h3').textContent = "THE INDEX NOT FOUND";
    document.querySelector('body').style.color = "white";
    document.querySelector('body').style.backgroundColor = 'red';
}