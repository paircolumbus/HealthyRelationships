#Healthy Relationships

__Skill Level:__ Intermediate  
__Time Limit:__ 30 minutes

Active Record is a object relational mapper that connects classes to relational database tables. These classes are commonly called __models__. Models can also be connected to other models by defining __associations__.

Under the surface, Active Record provides a level of abstraction that helps you reduce the amount of SQL you would have to write for simple and sometimes complex statements.

##Instructions
Fill out the migrations and models in the `associations.rb` file in such a way that the resulting methods produce the expected output. I've also included a few helper gems that should help with visualizing these models and their relationships.

```
class Person < ActiveRecord::Base  
  has_many :orders  
end

Person.create(name: Jill, age: 45)  
Person.orders << Order.create(description: "Pizza Boxes")  
p Person.orders.first => #<Order: id: 1, description: '...'>
```

##Resources
[Table Print Gem](http://tableprintgem.com/)  
[Awesome Print Gem](https://github.com/michaeldv/awesome_print)  
[Active Record Basics](http://guides.rubyonrails.org/active_record_basics.html)
