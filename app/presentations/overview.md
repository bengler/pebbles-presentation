# Pebbles Overview

# Pebbles
Pebbles is a discipline and a toolset for building applications by composing distributed, reusable services.

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

# Monolithic Web Apps: Simplicity incarnated
- A single piece of code to maintain
- Easy deployment
- Single, identifiable point of failure

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

# Our Goals with Pebbles

# Goals: Auth roaming
We must be able to share user profiles across applications, and provide a login that travels across hosts.

- Shared user database
- Traveling cookies

# Goals: Data sharing
**Data arrive, get processed and is delivered in the locations most convenient and valuable to our users.**

Storing the data in the app where it was created is like using an operating system without a file system.

# Goals: Deploy once, reuse everywhere
**A lot of data has similar sematics across services.**

Media uploads | Likes, kudos, votes | Objectionable content reports | Comments | Post-like records | User accounts, authentication, access-privileges | Organizational structure, roles

# Goals: Piecemeal upgrades
**Small, loosely coupled parts that can be refactored or upgraded individually where it makes most sense.**

Technology evolves. You are going to want to move to newer and better things. For huge things, it will never make business sense until catastrophy is imminent.

# Approach

# Interoperability: a few, simple standards
- Authorization and identification of user sessions
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
The "API only"-approach guarantees an API coverage of 100%

(*API-coverage*: The fraction of actions that an application performs on a set of data that is exposed through a public api.)

# Loose Coupling: The River
Pebbles may broadcast events to a global queue called The River. Others listen in and update their state in their own time.

- A blog post in ∴ _Grove_ gets broadcast and is picked up by ∴ _Sherlock_ and indexed for full text search.
- An access privilege is added to ∴ _Checkpoint_ and is broadcast. ∴ _Grove_, ∴&nbsp;_Sherlock_ and ∴ _Origami_ updates their table accordingly.

# Some examples

# Checking identity
```js
services.checkpoint.get('/identities/me').then(function(result){
  console.log(JSON.stringify(result));
});
```

# Logging in:

```html
<a href="#" onclick="services.checkpoint.login('twitter')">Log in</a>
```
<a href="" class="button" onclick="services.checkpoint.login('twitter'); return false">Log in</a>

# Identity record
```js
{
  "identity": { "id": 160408, "provisional": false, "realm": "apdm" },
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
```

# Displaying profile
```js
services.checkpoint.get("/identities/me").then(function(user) {
	$('#profile').html("<img src='"+user.profile.image_url+"'/> "+user.profile.name)
});
```
<p></p>
&lt;span id=&quot;profile&quot;&gt;<span id="profile"></span>&lt;/span&gt;
<br/><a class="button" onclick="__getProfile(); return(false);">Run</a>


# Post to blog

`services.grove.post("post.blog:amedia.ba.blogs.sport", :post => {…})`

Full text search:

`services.sherlock.get("post.blog:amedia.ba.blogs.*", :q => "searchterm")`

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

- Accepts votes by object identifier
- Different kinds of votes, different scores
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

# The major pebbles are FOSS

Work in progress: Publish all pebbles, libraries and tools.

http://pebblestack.org

http://github.com/bengler

# Production ready?
Yes.

We are running most of our pebbles in a production environment. Ops-wise they are our most "boring" applications.

They lack a sophisticated access control scheme. **On it!**

# Pick up and go? Yes and No

Client side with CORS: Very easy.

Getting the backend up and running: You'll need a little hand holding. **Will be a one-liner soon.**

# Getting into it?

- Start with the _readme_'s on github. 
- Then invite yourselves over for lunch!

# Over til Bjørge



# NOTES
- Kjøre litt kode i browseren
- The River og asynkronitet
