#### puppet 4.x conditional expressions

1. if () {} elsif () {} else {}

2. unless () {} else {}

3. case $var {
   $value1 : {}
   $value2 : {}
   default : {}
   }

4. $var = $var_ori ? {
   $value1 => $v1,
   $value2 => $v2,
   default => $v_default,
   }

5. regular expressions can be used in
  * if and unless statements
  * case statements
  * selectors
