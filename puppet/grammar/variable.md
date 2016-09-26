#### puppet 4.x variable

*valid for puppet 4.x only*

1. variable name rule 
* prefaced with $ character
* start with lowercase letter or underscore
* contain only lowercase letter, underscore, and number

2. number 
* $decimal	= 1234
* $decimal	= 12.34
* $octal	= 0775
* $hexdemcimal	= 0xFFAA
* $string	= '001234'

3. array
* $my_list	= [1,2,3,4,5]
* $mixed_up	= ['John',3,true]
* $enbeded 	= [4,5,['a','b']]

4. hash
* $homes	= { 'Jack' => '/home/jack', 'Jill' => '/home/jill', }
* $user		= {  
   'username'	=> 'Jill',  
   'uid'	=> 1001,  
   'create'	=> true,  
   } 

5.
