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

``` ruby Meditations gem source code
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
```