# Pebbles Overview

# Pebbles
Pebbles is a discipline and a toolset for building social applications by composing distributed, reusable services.

# A Selection of Reusable Social Features
- Identity and Authentication
- Document Store
- Full Text Search
- Modelling of Organizations and Roles
- Media Uploads
- Likes/Kudos/Votes
- …

# Motivation

# Perfection: The Classic DB-driven Web-app
![Perfection!](/pictures/overview/clientserver.jpg)

# But it gets hairy when you have to …
- share authentication across apps
- reuse data in other apps
- evolve into a full blown JS-app
- add a mobile app

You solve this by adding api-actions willy nilly …

# ![Hellish mess of interconnected apis](/pictures/overview/apihell.jpg)

# Problems ensue
- Teams are constantly waiting for other teams to fix apis
- Api-actions will be task-specific and hard to reuse
- Documentation will suck
- Hacks pile upon hacks

# Or: You solved it by writing everything inside one huge application. 

![Box of interconnected nightmares!](/pictures/overview/monolith_doom.jpg)

# Obviously, then:
![Box of interconnected nightmares!](/pictures/overview/soa.jpg)

# Service Oriented Architecture
> a set of principles and methodologies for designing and developing software in the form of interoperable services.

> <cite>Wikipedia</cite>

# ![Neat soa topology](/pictures/overview/topology.jpg)

# SOA is more than having lots of APIs

**Interoperability demands some well thought out conventions.**

# Pebbles Design Goals

# Goals: Auth roaming
**We must be able to share user profiles across applications, and provide a login that travels across hosts.**

# Goals: Data sharing
**Data are presented and manipulated in the locations most convenient and valuable to our users.**

Storing the data in the app where it was created is like using an operating system without a file system.

# Goals: Deploy once, reuse everywhere
**A lot of data has similar sematics across applications.**

Have a single service to use everywhere.

# Goals: Piecemeal upgrades
**Small, loosely coupled parts that can be refactored or upgraded individually where it makes most sense.**

- Technology evolves
- For huge apps it will never make business sense to upgrade until catastrophy is imminent

# Approach

# Interoperability: a few, simple standards
- Authorization and identification of user sessions (Checkpoint)
- A model for access privileges (PSM)
- Identifiers of individual objects (Uids)
- Broadcast events (The River)
- RESTful http, json, AMQP, CORS

# Division of labor: One thing, and one thing well
- Each set of closely related data gets its own service
- Minimize crosstalk: A well designed pebble does not need to talk to other pebbles (much)

# Encapsulation: The public API is the only interface
The API is the ONLY way anything is allowed to modify the data of the service. NO BACKDOORS.

The website is just another client.

# Full API coverage
**The "API only"-approach guarantees an API coverage of 100%**

API-coverage: The fraction of actions that an application performs on a set of data that is exposed through a public api.

# How to be a Pebble
- Be a http/json api
- Respect the url-schema `/api/<service>/v<version>/...`
- Respect Checkpoint and the session hash
- Respect [uids](https://github.com/bengler/pebbles-uid)
- Respect [CORS](https://github.com/bengler/pebbles-cors)
- Optionally: [The Pebbles Security Model](https://github.com/bengler/checkpoint/wiki/Pebbles-Security-Model)
- Apart from that: _Do what thou wilt shall be the whole of the standard._

# Tech and Ops

# Ops wins
- Scaling each service independently
- Measure load and usage per service
- Deploy new features weeks before they are used in apps

# The stack

- _Frontend:_ CoffeeScript, Backbone, Jade, Sass/Compass
- _Web server:_ Ruby, Sinatra, <strike>Rails</strike>
- _Data tier:_ Postgres, Memcached, RabbitMQ, ElasticSearch
- _Cloud:_ S3, SQS, EC2

But any language that can talk _http_ and _amqp_ can be a part of the _pebblesphere_.


# The Pebbles So far

# ∴ Checkpoint
The central authentication broker

- User profiles
- Login via Twitter, Facebook, Origo, Google and Vanilla
- Access privileges

# ∴ Vanilla
Custom branded accounts (e.g. Origo, Mitt Arbeiderparti)

- Alternative to Twitter etc. when logging in to ∴ Checkpoint
- Register account
- add email, mobile number
- Log in
- Reset password

# ∴ Grove
Document store

- E.g. Blog posts, band profiles, suggestions, tweets, events
- Organizes documents in trees, timelines, tagged sets
- Rich query api

# ∴ Kudu
Likes, kudos, votes

- Keeps track of votes, downvotes, plays, views, likes etc.
- Provide sorted lists and representative sets of objects

# ∴ Snitch
Reports of objectionable content and logs moderator work flow

# ∴ Sherlock
Full text search

- Listens for updates on The River and keeps a searchable index
- Full ElasticSearch-query-api

# ∴ Origami
Models the formal structure of organizations

- Associates, Units, groups, members, capacities, roles etc.
- Facilities for staying in sync with external data stores

# ∴ Tiramisu
Media and document uploads

- Handles handshaking and progress reports to the uploading client
- Handles asynchronous scaling, transcoding and uploading to S3
- Images, music, video and other documents

# ∴ Pulp
Knows "everything" about our partnering local papers

- Domain names
- Full names
- Publication days/Work days
- Geographic area (gis-polygon)
- Calculates submission deadlines for ads

# Pebbles Applications in Production
- Strider - Pedometer competition
- Ditt Forslag - Collect Suggestions for the Labor Party
- Bandwagon - A music competition
- Groom - Filter and approve user generated content
- Bagera Section - Present events in the news paper
- Parlor - Simple comment threads

# Partially Pebblified Apps
- Lifeloop - "Livsløpet" Birthdays, Weddings etc. 
- Origo - Social Publishing Monster

# Status

# Production ready?
**Yes.**

We are running most of our pebbles in a production environment. Ops-wise they are our most "boring" applications.

_They lack a sophisticated access control scheme. **On it!**_

# Pick up and go?

Client side with CORS: Very easy.

Run the backends: You'll need a little hand holding for now.

# What we are focusing on these days
- Security and access control [(PSM)](https://github.com/bengler/checkpoint/wiki/Pebbles-Security-Model)
- Cleaning up dev-tools
- Configuration and inspection apps (XRay)

# Pebbles are FOSS

Liberal do-anything license!

http://pebblestack.org


# Getting into it?

- Start with the _readme_'s on github. 
- Then invite yourselves over for lunch!

# That's it
