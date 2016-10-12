Part 1:

1. The assignment of 2 to the `str` variable persists outside of the loop because the variable was initialized outside of the loop.

2. The `str` variable was initialized within the loop therefore it's scope is local to the loop. It cannot be accessed outside of the loop. When it is used as an argument to puts, it does not exist within the scope of the puts method call.

3. It is not possible to say with certainty whether the code will run because there is no way of knowing if the `str` variable is available to the puts method. For it to be available to the puts method it would have to have been instantiated outside of the loop.

4. The `a_method` method call is attempting to pass the `str` argument to the puts method, but there is no `str` argument available in the scope of `a_method`. `str = 'hello' ` is outside the scope of `a_method`.

5. In this example `str` is initialized outside of the method definition, and within the same scope as the puts method call. This is why `puts str` outputs "hello". The str variable that is initialized within the `a_method` is local to that method only - it is a different object, with a different object_id, from the str variable that was initialized outside the method.

6. In line 3, a is reassigned to a new object, while b continues to point to the original object that was assigned to a. This reassignment results in b continuing to point to "hello", while a points to "hi world".

7. There are four variables (a, b, c and d).
   There are two objects ("hello" and "world"). When one variable is assigned to another (eg a = b ), a new object is not created. Both variables (a and b) are set to point to the same object.


h2. Mutating Method Arguments

1. The `greeting` variable is not modified by the `change` method because the `+` operator is non-mutating. It results in a new object being created, rather than modifying the caller. To change the greeting variable to "hello world", the method would need to be changed to use a `<<` operator, or line 6 would need to say `greeting = change(greeting)`

2. The `<<` operator is a mutating method. It modifies the caller, which results in the greeting object being changed outside of the `change` method.

3. In line 2, a new object is assigned to the param variable. This is the object that is mutated by the `<<` operator, so this is the object that has "world" appended to it. The original object is not changed, which is why the last line continues to output "hello".

4. This is the same case as the previous case. The `+=` operator is non-mutating. That's to say it creates a new object. This means that both lines 2 and 4 result in new objects being created and assigned to the param variable, so the mutating methods in lines 3 and 5 have no effect on the original object. It retains the value "hello".

h2. Working with Collections

1. Array#map takes a block and returns a new array containing the result of calling the block for each element of the array. The block doesn't have to actually use the elements in the array, it just gets run once for each element of the array.

2. Array#select takes a block and returns a new array containing each element of the original array for which the block returned true. 

3. The return value of `n + 1' is the same as the return value of `n += 1`. This is why both lines of code return the same result. (The map method uses the return value of the block.) `n + 1` is preferred because it's easier to read. There is no need to assign the result of `n + 1` to a new variable.

4. The map method returns an array containing the result of calling the block for each element of the array. In this case the result of calling the block ( `n > 2 `) will always be true or false, so this is what the returned array will contain.

5. A puts statement will always return nil, so `arr` will now be an array of nils.

6. Select returns each of the elements of the original array, for which the block evaluates to true. `n + 2` will always return an integer (assuming `n` itself is an integer), and this will evaluate to true. The means each of the elements from the original array will be selected, and the result will be a new array which is a duplicate of the original array.

7. In this case the return value of the block will be nil for every element of the array. This is because puts returns nil. Since nil evaluates to false, the end result will be an empty array.