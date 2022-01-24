# dropInRegistration

What does the app do?

dropInRegistration is a web application for managing a small group of hockey players who play drop hockey every Friday evening at Britannia Rink

the app includes functions for an administrator to group email hockey players advising them to login and register to play in the next drop in game. Each player must then login to claim their spot in the roster for the weekly game.

the app will allow registration of two goaltenders and twenty skaters per game. Once twenty skaters are registered, four more may be added to a wait list. If a registered player logs into the application and cancels their registration, the first player on the wait list is moved into the roster and automatically notified by email of the status change.

Once all available spots are filled including four on the wait list, new logins will see an error message advising that all spots are full and to try again next week.

Requirements to install and run this application from an IDE

	build the application and run in a tomcat web server
	
	open the app in a web browser at the following url
		http://localhost:8081/dropInRegistration


login as admin

  user name: admin
  password: admin
  
login as a player

  user name: snorrena@gmail.com
  password: snorrena@gmail.com
  
  
 Admin functions
 
 reset registrations:
 
    this will clear all player registration in the database (you probably don't want to do this when testing)
    
 email - new session:
 
    this will generate a boiler plate email invite to the next game for all players listed in the database
    
 email - roster status:
 
    this generates an email to all users advising of the current registrations for the next game
    
 maintenance:
 
    the maintenance buttons opens a page for the administrator to manually adjust the status of all players. It also includes functions for adding or 
    deleting a player from the database
     
    
   Player functions
   
   On login, a new player will see a button to join the upcoming game if space is available or an error message if the roster is full.
   
   If the player is already registered, they will see a button that will allow for cancellation.
   
   If a registered player cancels, the first person on the wait list is moved into the roster and notified by email of their status change.
   
   Technical stack:
   
   dropInRegistration is a java based application that uses java server pages and a sqlite database on the backend. The app
   is designed to be packaged as a war file for execution inside an java application server such as Tomcat.
   
Other misc. notes:

edit the sqlite database and log4j log path(s) according to platform ie Linux vs Windows
ie the path to the database file will change based on the file system structure and the location
of the project root folder

add a new email address for mail function before putting into production
ex. fridaynighthockey@gmail.com

edit project facets -- add dynamic web module 3.1 and change java to 1.8, remove
webdoclet this is needed to add run on server from eclipse

make certain that the database file can be located from the path string in CRUD.java
