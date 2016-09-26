#### Variable and Resources

1. pass hash to resource defintion
  * use attribute name of * (splat) with a value of hash

2. multiple resource title
  * RESOURCE_TYPE { ['title1','title2']: ... }
  * RESOURCE_TYPE { 'title1': ... ; 'title2': ...; }
  * RESOURCE_TYPE { default: ... ; 'title1': ...; 'title2': ...; }

3. Array concatenation and appending
  * concatenation -> 
    $small_list = [1,2,3]
    $big_list = $small_list + [4,5] 	# equals [1,2,3,4,5]
  * appenda ->
    $longer_list = $small_list << [4,5] # equals [1,2,3,[4,5]]

4. remove from array and hash
  * $short_list = [1,2,3,4,5] - [4,5] 	# equals [1,2,3]
  * $user = {name => 'John', uid => 1001, gid => 1001 }
    $no_name = $user - 'name' 		# equals {uid => 1001, gid => 1001}

5. comparison operators
  * numberic: != < >
  * string: ==(case insensitive) in(case sensitive) 
  * array and hash: =(same length and value) 
  * values and datatype: $not_true =~ Boolean
