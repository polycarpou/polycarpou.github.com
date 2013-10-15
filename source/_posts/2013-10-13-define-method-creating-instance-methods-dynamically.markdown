---
layout: post
title: "define_method: creating methods dynamically"
date: 2013-10-13 16:49
comments: true
categories: [Ruby, Metaprogramming]
---

One of the first things that I personally learned to do when I was starting out with Ruby was how to create methods using 'def method'. I started learning ruby using the amazing tutorials at [Codecademy](http://http://www.codecademy.com/tracks/ruby). The task was always create a method that would do this, this and this. 

``` ruby A standard method definition 
def a_method(arg)
  puts arg
end
```
<!-- more -->
Now a couple days ago we had a morning todo that wanted us to create a class that would have a mass assignment of properties at initialisation according to a hash given to the argument. This would basically require us to create methods when the program was running. I was like whaat? To figure out how to get around this problem I did what any citizen of 2013 earth would do. I googled it. 

I found an answer online that worked but I didnt really understand what was actually happening. It used the send method along with a so called :define_method symbol. I was confused. After doing my homework, I am here to explain this clearly to anyone that is trying to understand what is the deal with this define_method stuff. Here it goes. 

The first way to create methods is using the define_method keyword by itself. 

``` ruby How to create instance methods dynamically 
class Car
  [:engine_size, :engine_type, :transmission].each do |method_name|
    define_method(method_name) do |argument|
      "This car has got #{argument}"
    end
  end
end

new_car = Car.new
new_car.engine_size("6 Cylinders")
 => "This car has got 6 Cylinders" 
```
``` ruby How to create the same methods statically
class Car
  def engine_size(argument)
      "This car has got #{argument}"
  end
  def engine_type(argument)
    "This car has got #{argument}"
  end 
  def transmission(argument)
    "This car has got #{argument}"
  end
end
```

The define_method takes in the parameter in the parenthesis which it interprets as the name of the method to be created. It then takes in a block. The block variable(s) is interpretted as the argument(s) to the method. 

Now say we want to do the same thing but from within another method, like the initialize method. We can't use define_method by itself as we did previously since it is not in scope within another method. To get around this problem we use the .send method as follows. 

``` ruby input hash
car_hash = {
  "camry" => "Toyota",
  "civic" => "Honda",
  "focus" => "Ford",
  "beatle" => "Volkswagen"
  }
```
``` ruby Creating instance methods from within another method linenos:false

class CarDealer
  def initialize(car_hash)  
    car_hash.each do |model,brand|
      self.class.send(:define_method, model) do |quantity|
        "You have #{quantity} #{brand} #{model} in the lot"
      end
    end
  end
end
```

``` ruby Calling the instance
new_car_dealer = CarDealer.new(car_hash)
p new_car_dealer.camry("six")
 => "You have six Toyota camry in the lot"  
```

Instead of having an instance method such as the initialize method generating the other methods, we could have a class method that would create the intance methods. I am not sure whether it is better to have our generating code methods as instance or class methods. It definitely depends on the circumstances we have in our program. Luckily Ruby allows us to do either. 

``` ruby class method that generates instance methods
class CarDealer
  def self.method_creator(car_hash)  
    car_hash.each do |model,brand|
      define_method(model) do |quantity|
        "You have #{quantity} #{brand} #{model} in the lot"
      end
    end
  end
end
```
``` ruby Calling the class method that generates instance methods
CarDealer.method_generator(car_hash)
ny_cars = CarDealer.new
ny_cars.beatle("four")
 => "You have four Volkswagen beatle in the lot" 
```
<!--
Up until this point we have always been generating instance methods. These are the methods that we are used to. We create an instance of a class and then we call the method on this instance. There is also the option to generate class methods. Class methods are called directly from the class. To do this we use the singleton_method instead of define_method. A singleton in ruby means a class. We call it like this since you can have many instances of a class but only a single class. 
-->

