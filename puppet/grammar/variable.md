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

5. variable in string
  * single quotes for pure data
  * double quotes to interpolate variable into string
  * heredoc @() for large block of text
  * "$my_list[1]" output all values after index 1
  * "${my_list[1]}" outpuet only index 1 value
  * use backslash \ to avoid interpolation of $

6. rules of wisdom
  * avoid redefintion. A variable cannot receive a new value within same namespace
  * avoid reserved words
