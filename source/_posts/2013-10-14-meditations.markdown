---
layout: post
title: "meditations"
date: 2013-10-14 21:15
comments: true
categories: [Ruby, Gems]
---

Marcus Aurelius was a Roman Emperor from 161 to 180 AD. He is considered as the last of the five good emperors and is also known as one of the most important Stoic philosophers. 

He wrote a book called 'The Meditations' which was a sort of diary for self improvement and guidance. The title was added after he died. He called this book as simply "To Myself". 

Almost two thousand years later his quotes still have much to teach people. In my case it was how to create my first ruby gem!
<!-- more -->

The Meditations is filled with deep and motivational quotes. My goal was to create a gem called the 'meditations' that would take in the book Marcus wrote and randomly return one of his quotes when called. 

I downloaded the book from [MIT classics](http://classics.mit.edu/Antoninus/meditations.html) and included it into the gem file. 

I followed the [online guide of how to create ruby gems](http://guides.rubygems.org/make-your-own-gem/). They are a lot easier to make than I thought it would be. 

I created a class called Meditations which is the same as what the gem is called. The thing that took the most time on this little side project was to figure out how to include the correct filename. After struggling for a while Spencer and Jon helped me figure out the correct syntax for requiring gemfiles which is seen in the code below.

I then cleaned up the code from the book using several gsub methods and then split the book into quotes using regular expressions. 

I then have two class methods. The one which is used most of the time is Meditations.quote which outputs a random quote from the book and the other is the Meditations.all method which gives all of the quotes. 


    class Meditations
      path = File.join(File.dirname(File.expand_path(__FILE__)), "meditations/the_meditations_book.txt")
      @@quotes = File.read(path)
      @@quotes.gsub!("----------------------------------------------------------------------\n", "")
      @@quotes = @@quotes.split(/\n\n/)
      def self.all
        @@quotes.each do |q|
          q.gsub!("\n", "")
          puts q
          puts puts
        end
      end
      def self.quote
        @@quotes[rand(0..@@quotes.count)].gsub!("\n", " ")
      end
    end

To turn this into a gem we had first sign up for an account at rubygems.org. We then organise the structure of the file you want to upload so that the main directory has a meditations.gemspec file and a lib directory. Note that meditations is the name of the gem. A person creating a new gem would replace this with the name of their gem. 

The .gemspec file contained the following code written in ruby. 

    Gem::Specification.new do |s|
      s.name        = 'meditations'
      s.version     = '0.0.1'
      s.date        = '2013-10-14'
      s.summary     = "Returns a quote from Marcus Aurelius book, The Meditations"
      s.description = "It takes the book called Meditations by the Roman Emperor Marcus Aurelius and splits it into memorable quotes. The gem has two class methods. The Meditations.all which returns all fo the quotes in the book and Meditations.quote which just returns a randomly chosen quote."
      s.authors     = ["Michael Polycarpou"]
      s.email       = 'michaelpolycarpou@gmail.com'
      s.require_path= 'lib'
      s.files       = ["lib/meditations.rb", "lib/meditations/the_meditations_book.txt"]
      s.homepage    =
        'http://rubygems.org/gems/meditations'
      s.license       = 'MIT'
    end

The lib directory contains meditations.rb which is called the same thing as the gem and is run when the gem is called. This contained my code for the Meditation class. 

Lastly, I created another directory in the lib folder called Meditations which had all of the extra files needed for the gem. In my case, this was just the actual book which I called 'the_meditations_book.txt'. This is in lib/meditations/the_meditations_book.txt. 

We then want to test if this works as a gem on our local machine. We run the folling commands. 

    $ gem build meditations.gemspec

    $ gem install ./meditations-0.0.0.gem

We then test this in an irb terminal. We open irb with an extra handle so that is can locate the extra gem files. 

    $ irb -Ilib
we then require 'meditations' as you would any gem and test to see if it works. 

The final step is to push it to RubyGems.org so that everyone else can download your amazing gem! 

To do this we simply:
    $ gem push meditations-0.0.0.gem
and give your credentials. If there were no problems other people will be able to simply gem install meditations and try it out! 


I had a lot of fun building my first gem and I hope there will be many more to follow!
    
    require 'meditations'

    Meditations.quote
     => "If a thing is difficult to be accomplished by thyself, do not think that it is impossible for man: but if anything is possible for man and conformable to his nature, think that this can be attained by thyself too. "

