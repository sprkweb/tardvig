# Tardvig [![Gem Version](https://badge.fury.io/rb/tardvig.svg)](https://badge.fury.io/rb/tardvig)

[RubyGem](https://rubygems.org/gems/tardvig) |
[RubyDoc](http://www.rubydoc.info/gems/tardvig) |
[GitHub](https://github.com/sprkweb/tardvig)

**Warning!** I do **not** recommend to use it.
This gem is in the alpha stage of development now and it is very badly written
and it does almost nothing.

My English is very bad. Please, do not be mad at me. You can correct my errors
if you want.

## Description
Lightweight structure for Ruby-based game engines.

In fact, this is just a bundle of several simple helpful classes and modules
which can be integrated and extended to make a game engine.

### What is it for?
It was developed for my single-player browser game which is divided into levels,
but probably this gem can be used for any other types of games with any IO, I
tried to make it as flexible as possible.
For example, I used a similar structure for my text-based game with console IO
earlier.

*Important!* I recommend to familiarize with this gem before using it because
it may be not applicable to your game.

## Getting Started
Tardvig consists of some modules and classes (i will call them "parts"). In this
guide I am not going to describe them, because you already have docs as their
description and specs as their examples. I'll tell you what you should pay
attention to.
I recommend you to read the description of parts immediately
after you noticed their names so you can understand further guide (however, the
guide is short).

`Events` mixin and `Command` class are base parts which are not related directly
to the game structure, but are very useful for parts which are related to it.

The main part of a Tardvig-based game is `Act` class. Game is a sequence of
acts. Acts can have different types.
Example: Tardvig-based 3D FPS would be a sequence of acts of types `shooting`
(user can run and shoot; each location is an act) and `cutscene` (user watches
video), finished with a `credits` act (user watches authors' names).

Important fact is that acts have attribute `subject`.

Acts have attribute `io` which should contain an instance of any class which
gives you ability to communicate with something that will dislay your game.
I recommend you to communicate via `GameIO`.

Well, now you know the basic parts. Final thing you should to do before you can
use this gem is reading the example. It takes place in the
`spec/integration_spec.rb` file.

## You can also see...
`Rakefile` - Rake tasks for contribution

`tardvig.gemspec` - here you can see my name and email and this gem's depencies

`LICENSE` - this gem's license
