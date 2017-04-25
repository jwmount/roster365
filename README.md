==Roster365

An ActiveAdmin based Ruby on Rails application created to satisfy several hundred user stories.

A classic case of scope creep by a client who needed to exercise authority over the development process
with very little understanding of the need to think things through.   

This code became too deeply nested and unstable as no QA or sustained TDD regime could be sustained.  In hind sight it 
also should have been defined from the onset to be a family of related applications.  In other words in this fashion and 
a number of others it became too closely coupled and probably would have been difficult to support.  (But we didn't have to,
the same people who refused to allow appropriate development methods destroyed the client company, oh well.)

While there's a lot to learn from this about the application involved you would not tackle this project this way again.  
For one thing it would work better as a set of micro services.  For another the ActiveAdmin CRUD oriented UI was stretched beyond 
its design intent (which is no fault of its own) and the result was the time to complete data capture began to exceed the time 
available to respond and there was no obvious way to alleviate this constraint without deeply refactoring the user stories themselves.  


