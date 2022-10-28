# Road_Route_Search_AI_Assignment2
AI Assignment 2 for road route search using Depth First Search and Best First Search

HOW TO RUN THE CODE?
============================================

STEP I: CONSTRUCT facts.pl FILE
---------------------------------------
Step 1: Run extract_facts.pl file
_____________________________________

To run this file, consult it in prolog and then type
<br>
?- csv('c:/Users/roaddistance.csv')          % complete path of csv file
<br>
true.

?- save.
<br>
true.

Now the facts.pl will be saved in path as written in Line No. 33 of extract_facts.pl

Step 2: Make some changes in facts.pl file
_____________________________________
Make sure that distance(A,A,-) is changed to distance(A,A,0) and other such facts are also inserted.
<br>
Write a simple script to perform the same.


STEP II: RUN main.pl FILE
---------------------------------------
Simply run main.pl file to perform best first search and depth first search.
