## Table of Contents

1. [Context](#context)
2. [Project Requirements](#project-requirements)
3. [How to run](#how-to-run)
4. [References](#references)
5. [My other work](#my-other-work)

# Context
My first ever Elixir line of code has been written here.

I wanted to challenge my self and learn a new language/framework (the basics for start) in less then a week so I choose Elixir and Phoenix LiveView even though I was never in touch with them before. Phoenix LV makes the multiplayer implementatino of the game much easier.
 
It was a very fun journey btw!
 
Note: Regarding the multiplayer mode, I have the implementation in my head and I know it would take somebody who know Pheonix LiveView better 20 minutes to write it in this project but I don't have much more time at the moment and it would take me a bit more time. Maybe I will do it later.
 
# Project Requirements

Click [here](REQUIREMENTS.pdf) to read the project requirements

# How to run

### Prerequisite

* Elixir v1.14 - https://elixir-lang.org/install.html

### Configurations
* Default port is http://localhost:4000

### How to Run
* Install dependencies with mix deps.get
* Start Phoenix endpoint with `mix phx.server` or inside IEx with `iex -S mix phx.server`

Now you can visit [`localhost:4000`](http://localhost:4000) from your browser.


# References

* Read Elixir's [Getting started](https://elixir-lang.org/getting-started) Guide
* Watched Phoenix LiveView [Crash Course](https://www.youtube.com/watch?v=U_Pe8Ru06fM)  by James Moore
* Got initial inspiration from https://github.com/drewfravert/2048 
* Guides that gave me inspiration for writing concise and easy to read Grid.move() function [Elixir comprehension](https://www.mitchellhanberg.com/the-comprehensive-guide-to-elixirs-for-comprehension/) and 
[Kernel.SpecialForms](https://hexdocs.pm/elixir/Kernel.SpecialForms.html#for/1)
* As I was getting more familiar with Elixir I learned that I should have using pattern matching much more like I have seen in this implementation of [2048 Game](https://github.com/martinsvalin/lv2048/blob/master/lib/lv2048/grid.ex) 


# My other work
### Homework Tasks
* DB design and queries for high load [LINK](https://github.com/harisbotic/hiring-tool-db-design)
* Palindrome finder algorithm task with unit testing [LINK](https://github.com/harisbotic/palindrome-finder)
* File explorer problem (with DB stackoverflow prevention) [LINK](https://github.com/harisbotic/simple-file-explorer)

### My Blogs
I just started one and it's still work in progress and I am happy to share it with you
* Separating Domain and Persistence logic [LINK](https://docs.google.com/document/d/1XiOxjL9mkhNoJOthrLRX9VSzO7YXH1nxVU3P_jUcl8k/edit?usp=sharing)

### Open source contributions
I have this one amazing contribution to Linear, check it out :D

* [https://github.com/linear/linear/pull/104](https://github.com/linear/linear/pull/104)

# Screenshot

<img width="550" alt="image" src="https://user-images.githubusercontent.com/6454831/204549710-dec3777d-dd32-4794-a31c-093a4ac9f4cb.png">
