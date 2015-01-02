# 7. Create a class 'Student' with attributes name and grade. Do NOT make the grade getter public, so joe.grade will raise an error. Create a better_grade_than? method, that you can call like so...

#Student class
class Student
  attr_accessor :name

  @@number_of_students = 0

  def initialize(name, grade)
    @name = name
    @grade = grade

    @@number_of_students += 1
  end

  def self.tell_number_of_students
    puts "Students: #{@@number_of_students}"
  end

  def self.compare_two_students(student1, student2)
    comparison = student1.better_grade_than? student2
    puts "Is #{student1.name}'s grade better than #{student2.name}'s grade? #{comparison}"
    comparison
  end

  def better_grade_than?(other_student)
    self.grade > other_student.grade
  end

  def to_s
    "#{self.class} #{name}."
  end

  protected

  def grade
    @grade
  end

  def self.number_of_students
    @@number_of_students
  end
end

#Methods to help organize and test the classes and instance and class methods
def say_title(something)
  puts "#{"-"*10}#{something}#{"-"*10}"
end

def say(something)
  puts something
end

#---------------------------
#----------CODE-------------
#---------------------------

system "clear"
say_title "Test Student Class"
Student.tell_number_of_students

reillywj = Student.new("William Reilly", 95)
Student.tell_number_of_students
sheride = Student.new("Erinn Sheridan", 97)
Student.tell_number_of_students
another_student = Student.new("Another Student", 65)
Student.tell_number_of_students

say reillywj
say sheride
say Student.compare_two_students(reillywj, sheride)

say reillywj
say another_student
say Student.compare_two_students(reillywj, another_student)

say_title "-"*40 #Nothing


# 8. Answer
say_title "Answer to Exercise 8"
say "hi is either defined as a protected method or a private method in Person class.  You cannot access this method outside the class Person."
say_title "Solution"
say "Either remove it from private/protected method area."
say "Or create another method in the class that uses the hi method such as say(hi) and then call this public method on the Person object."






