---
layout: post
title: "To vim or not to vim"
date: 2013-10-28 20:46
comments: true
categories: 
---
This week I started learning how to use Vim. I had used it briefly a couple summers ago when I was working for an engineering company. I first heard about Vim on the first day at this company. I had just started my internship and in the afternoon they introduced me and another intern to the Engineers that we were going to be sharing an office with.

One of the guys in the office asked us if we were Vim boys or Emacs Men. Neither of us knew what either one was, and we told him that. 
Well he replied, Emacs is the best text editor ever created by man and Vim is a wannabe second. The previously quiet room burst into uproar. It was like hearing Englishmen talk about the football teams they supported. At the time I was pretty confused. After everyone settled down I looked around and saw Vim and Emacs slogans written all over the place. I was bewildered. 

Vim is a text editor designed for super users (programmers). Vim allows you to do everything using just keyboard commands so that you never have to touch the mouse. The idea is, whenever you move your hands from the keyboard you lose efficiency. 

Vim is also very useful when you are ssh'ing into a remote server with a terminal. When you want to alter a file on the server you cant just open a GUI text editor such as Sublime as you would do if it was on your own machine. Even if you have Sublime installed on the remote server you wont be able to open it through a standard ssh connection. The alternative is to use something like 'nano' which is an extremely limited editor. Vim or Vi(vim before it was improved) is installed on pretty much any unix based machine. 

One thing that struck me when first learning vim is how completely different it was to anything I had ever used before. Menu bars, copy pasting, even typing letters. Nothing worked. It lived in its own little world. 

Vim has two main modes of functionality. You can either be in Command or in Insert mode. Insert mode is what we are used to. Typing words actually puts them on the screen! Now, if we are not supposed to use the mouse or arrow keys, then how are we supposed to navigate and manipulate the text we already have? Well, the answer to this is the command mode. By tapping the escape key while in insert mode we enter command mode. Here we use the keyboard in a completely different way. Each of the keys does something else. The h,j,k,l keys are use to go left, down, up, right respectively. 'w' goes to the beginning of the next word, 'e' goes to the end of the word, 'd' deletes. It makes little sense and it is even harder to remember. 



