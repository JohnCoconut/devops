#### lambda functions

1. `each()`
  * returns the value unchanged
  * acts on each entry in an array, or key/value pair in a hash
  * invokes a lambda oncie for each entry in a array, or each key/value pair in a hash
  * passing one argument to array, argument => value 
  * passing two arguments to array, first-argument => index, second-argument => value
  * passing one argument to hash, argument[0] => key, argument[1] => value
  * passing two arguments to hash, first-argument => key, second-argument => value
  * `reverse_each()` and `step()`

2. `filter`
  * return a subset of an array or hash
  * filter is applied by code inside lambda block
  * element is returned if lambda evaluates to `true`

3. `map`
  * returns a array, the element of which is the result of lambda function 
  * acts to every entry in an array, or key/value pair in a hash
  * apply lambda function to each entry and return a value
  * the value passed to resultant array

4. `reduce`
  * 
