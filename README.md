Optionals
=========
[![Build Status](https://travis-ci.org/TuvokVersatileKolinahr/optionals.svg?branch=master)](https://travis-ci.org/TuvokVersatileKolinahr/optionals)

This is optional, also called an optional illusion. And also something that is but might not be.

### installation
Prerequisite is a working global installation of bower (`(sudo) npm install -g bower`) and gulp (`(sudo) npm install -g gulp`)

Download sources

run:

	npm install
    bower install
    
  Create a github oauth token @ [Personal access tokens](https://github.com/settings/applications) and copy the token that is generated (e.g. a2pzaGZhaXJzZmprYnZhZmdobHNha2pmaGxrYWpo). Then:
	
	gulp build
	gulp serve --oauth_token a2pzaGZhaXJzZmprYnZhZmdobHNha2pmaGxrYWpo

go!

##### 'production use'

Download sources

run:

	npm install
    bower install
    gulp build --oauth_token a2pzaGZhaXJzZmprYnZhZmdobHNha2pmaGxrYWpo
	npm start
  
go!

**REMINDER**
This is development software. It is not intended to use in production.

#####cleaning

run:

	gulp clean


### For inspiration
Components used:

* [NG Sortable](https://github.com/a5hik/ng-sortable)
* [Octokat.js](https://github.com/philschatz/octokat.js)
* [Issues | GitHub API](https://developer.github.com/v3/issues/)
