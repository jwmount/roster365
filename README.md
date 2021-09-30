==Roster365

An ActiveAdmin based Ruby on Rails application created to satisfy several hundred user stories.  Uses ActiveAdmin for the GUI of the business logic and equally ActiveAdmin to conduct the administrative services.  This leads to a well formed but sometimes overly intricate UI throughout. 

This code became too deeply nested and unstable as no QA or sustained TDD regime could be sustained.  In hindsight it 
also should have been defined from the onset to be a family of related applications.  In other words in this fashion and 
a number of others it became too closely coupled and probably would have been difficult to support.

While there's a lot to learn from this about the application involved you would not tackle this project this way again.  
For one thing it seems likely it would work better as a set of micro services.  For another the ActiveAdmin CRUD oriented UI was stretched beyond 
its design intent (which is no fault of its own) and the result was the time to complete data capture began to exceed the time 
available to respond and there was no obvious way to alleviate this constraint without deeply refactoring the user stories themselves.  

===Upgrade to Rails 5.2.2
1.  Rebuild gems using bundler and resolve conflicts
2.  Revise scope statements (incompatible as not based on callable blocks before 4.x)


Copyright 2011 - 2021 by John W. Mount
