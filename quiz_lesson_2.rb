#Quiz: Lesson 2

# 1. Name what each of the below is

a = 1             #local variable pointing at place in memory that stores 1
@a = 2            #object instance variable set to 2
user = User.new   #initialize User object stored in the local variable user
user.name         #calling the method name on the local variable user and returns whatever the name method returns
user.name = "Joe" #sets the instance variable name in the user's User object to the string "Joe"

# 2. How does a class mixin a module?
# Answer: include ModuleToMixin

# 3. What's the difference between class variables and instance variables?
# Answer: Class variables have @@ prefix and stores class information
# Answer: Instance variables have @ prefex and stores object states

# 4. What does attr_accessor do?
# Answer: creates getter and setter methods for the symbols following the call

# 5. How would you describe this expression: Dog.some_method?
# Answer: It's a class method call of some_method that calls some_method from the Dog class.

# 6. In Ruby, what's the difference between subclassing and mixing in modules?
# Answer: subclassing is a "is a relationship" where an object inherits states/behaviors from its superclass
# Answer: mixing in modules allows for "has a realtionships" and multiple behaviors can be added to any class.

# 7. Given that I can instantiate a user like this: User.new('Bob'), what would the intialize method look like for the User class?
# Answer:
def initialize(name)
  @name = name
end

# 8. Can you call instance methods of the same class from other instance methods in that class?
# Answer: Yes

# 9. When you get stuck, what's the process you use to try to trap the error?
# Answer: Debugging.  I like using the pry gem and binding.pry
