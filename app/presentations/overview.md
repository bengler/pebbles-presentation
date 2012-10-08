# Pebbles Overview

# Pebbles
Pebbles is a discipline and a toolset for building applications by composing reusable, distributed RESTful services.

# The Classic DB-driven Web-app
![Perfection!](/pictures/overview/clientserver.jpg)

# Monolithic Web Apps: Simplicity incarnated
- A single piece of code to maintain
- Easy deployment
- Single, identifiable point of failure

# But it gets hairy when …
- You need to share authentication across apps
- Data needs to travel across different apps
- You need to "federate" apps as sections in a single brand
- Your app evolves into a full blown JS-app
- You add mobile apps to the mix

# You solve this by adding api-actions willy nilly

![Hellish mess of interconnected apis](/pictures/overview/apihell.jpg)

# Simplicity goes out the window
The quiet zen garden that was your insular db-driven web-app is now a player in an unwieldy dependency-hell of interconnected ill defined apis.

# Problems ensue
- Teams are constantly waiting for other teams to add or revise api-endpoints
- Typical api-actions will be task specific and hard to reuse
- The documentation will suck
- Hacks pile upon hacks

# Or …
You solved it by writing everything inside one huge application. 

# Congrats! You are now refactoring in hell

![Box of interconnected nightmares!](/pictures/overview/monolith_doom.jpg)

# Obviously, then: Service Oriented Architecture
> a set of principles and methodologies for designing and developing software in the form of interoperable services. These services are well-defined business functionalities that are built as software components that can be reused for different purposes. 
> <cite>Wikipedia</cite>

# Our Goals with Pebbles

# Goals: Auth roaming
We must be able to share user profiles across applications, and provide a login that travels across hosts.

- Shared user database
- Traveling cookies

# Goals: Data sharing
Data arrive, get processed and is delivered in the locations most convenient and valuable to our users.

Storing the data in the app where it was created is like using an operating system without a file system.

# ![Groom architecture](/pictures/overview/groom.jpg)

# Goals: Deploy once, reuse everywhere
A lot of data has similar sematics across services

Media uploads | Likes, kudos, votes | Objectionable content reports | Comments | Post-like records | User accounts, authentication, access-privileges | Organizational structure, roles

# Goals: Piecemeal upgrades
Technology evolves. You are going to want to move to newer and better things. If your thing is huge and coupled enough, it will never make business sense to do so until catastrophy is imminent.

Small, loosely coupled parts that can be refactored or upgraded individually where it makes most sense.

# Approach
- Interoperability: a few, simple standards
- Division of labor: One thing, and one thing well
- Coverage: Design APIs first, everything goes through the api
- Encapsulation: Even the website is an api client

# A few, simple standards
- Authorization and identification of user sessions
- Identification of individual objects (Uids)
- Broadcast events: The River
- RESTful http, json, AMQP, CORS

# One thing, and one thing well
- Each set of closely related data gets its own service
- Minimize crosstalk: A well designed pebble does not need to talk to other pebbles (much)

# API first
- A pebble is a headless RESTful http/json api
- Designed for current requirements with an eye for future requirements, consistency and completeness
- All apis are public, security is implemented in the service

# API coverage
*API-coverage*: The fraction of actions that an application performs on a set of data that is exposed through a public api.

- The "API first"-approach guarantees an API coverage of 100%
 
# Encapsulation
The API is the ONLY way anything is allowed to modify the data of the service.

The javascript embed, the Android app, even the website MUST go through the apis.

# The Website is a Client
- The services model the application data
- The applications present them and allow for their manipulation
- The website doesn't get to have a database anymore. It is just another client. Increasingly it isn't even the most important client, anyway.

# The River
Pebbles may broadcast events to a global queue called The River. Other pebbles listens to this queue and updates their state. Examples:

- A blog post in _Grove_ gets broadcast and is picked up by _Sherlock_ and indexed for full text search.
- An access privilege is added to _Checkpoint_ and is broadcast. _Grove_, _Sherlock_ and _Origami_ updates their table accordingly.

# But what about apps with unusual requirements
- Make a custom pebble. 
- You will not waste any time, and you get to build your site as a proper, modern javascript app. 
- When the inevitable data-sharing, embed or app is requested you are off to a flying start.

# Some examples

# Logging in
- Direct user to `/api/checkpoint/v1/login/twitter`
- Checkpoint negotiates authentication
- Cookie: `checkpoint.session == 'hg8w1xxm1ij4zifhqtj7kfl3pjvthf94z5m…'`
- User will now be authenticated with all pebbles

# Checking identity
- `pebbles.checkpoint.get("/identities/me")`

# Identity record
    {
      "identity": {
        "id": 160408,
        "provisional": false,
        "realm": "apdm"
      },
      "accounts": ["twitter"],
      "profile": {
        "description": "Gartner på Underskog og idémann hos Bengler",
        "image_url": "http://a0.twimg.com/profile_images ...",
        "name": "Simen Svale Skogsrud",
        "nickname": "svale",
        "profile_url": "http://twitter.com/svale",
        "provider": "twitter"
      }
    }

# Post to blog

`pebbles.grove.post("post.blog:amedia.ba.blogs.sport", :post => {…})`

Full text search:

`pebbles.sherlock.get("post.blog:amedia.ba.blogs.*", :q => "…")`

# The Pebbles So far


# Checkpoint
The central authentication broker

- User profiles
- Login via Twitter, Facebook, Origo, Google and Vanilla
- Access privileges
- Realms and domains

# Vanilla
Custom branded accounts (e.g. Origo, Mitt Arbeiderparti)

- Alternative to Twitter etc. when logging in to Checkpoint
- Register account
- add email, mobile number
- Log in
- Reset password

# Grove
Document store

- E.g. Blog posts, band profiles, suggestions, tweets, events
- Organizes documents in trees, timelines, tagged sets
- Rich query api

# Kudu
Likes, kudos, votes

- Accepts votes by object identifier
- Different kinds of votes, different scores
- Provide sorted lists and representative sets of objects

# Snitch
Reports of objectionable content and logs moderator work flow

# Sherlock
Full text search

- Listens for updates on The River and keeps a searchable index
- Full ElasticSearch-query-api

# Origami
Models the formal structure of organizations

- Associates, Units, groups, members, capacities, roles etc.
- Facilities for staying in sync with external data stores

# Tiramisu
Media and document uploads

- Handles handshaking and progress reports to the uploading client
- Handles asynchronous scaling, transcoding and uploading to S3
- Images, music, video and other documents

# Pulp
Knows "everything" about our partnering local papers

- Domain names
- Full names
- Publication days/Work days
- Geographic area (gis-polygon)
- Calculates submission deadlines for ads

# Pebbles Applications
- Strider - Pedometer competition
- Ditt Forslag - Collect Suggestions for the Labor Party
- Bandwagon - A music competition
- Groom - Filter and approve user generated content
- Bagera Section - Present events in the news paper
- Parlor - Simple comment threads

# Partially Pebbelized Apps
- Lifeloop - "Livsløpet" Birthdays, Weddings etc. 
- Origo - Social Publishing Monster

# Strider
An example of a super-custom pebble used for a pedometer competition in Lofotposten.

- _Checkpoint_ for login
- _Strider_ for data gathering, statistics and ranking

# Ditt Forslag
Suggestions to the Labor Party

- _Checkpoint_ for login and anonymous sessions
- _Grove_ for storing suggestions
- _Kudu_ for votes, rankings, and "representative sampling"
- _Snitch_ for objectionable content reports

# Bandwagon
Music competition

- _Checkpoint_ for login and anonymous sessions
- _Grove_ for band profiles and song metadata
- _Kudu_ for votes and ranking
- _Tiramisu_ for uploading songs (convert "anything" to mp3) and images
- _Snitch_ for objectionable content reports

# Groom
Moderator toolbox

- _Checkpoint_ for login
- _Grove_ for content
- _Snitch_ for reports and moderator audit logs
- _Sherlock_ for search

# Bagera Section
Data from the calendaring app Bagera presented as a section in the newspaper website

- _Grove_ for content
- _Snitch_ for objectionable content reports
- _Sherlock_ for search
- _Pulp_ for coverage areas


# Parlor
Comment threads

- _Checkpoint_ for login
- _Grove_ for comments
- _Snitch_ for objection  able content reports
- _Kudu_ for "Likes"

# Lifeloop
Uses _Tiramisu_ for media uploads

# Status

# The major pebbles are FOSS

Work in progress: Publish all pebbles, libraries and tools.

http://pebblestack.org

http://github.com/bengler

# Production ready?
Yes.

We are running most of our pebbles in a production environment. Ops-wise they are our most "boring" applications.

They lack a sophisticated access control scheme. _On it!_

# Pick up and go?

Yes: Client side with CORS: Very easy.

No: Developers need a little hand holding to get started. _On it!_

Dev-tools only OS X lately. Deployed on Ubuntu, so should be easy.

# Over til Bjørge


# Demo

http://blog.pebblestack.org


# NOTES
- Hvilke praktiske ting vi har løst: tidligere
- Kjøre litt kode i browseren
- The River og asynkronitet
- Ta bort ref til realms og domains
- Kursiv på alle pebbles-navn? (alt. Therefore)