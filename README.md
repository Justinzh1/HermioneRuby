# Project Hermione
[![Build Status](https://travis-ci.org/Justinzh1/HermioneRuby.svg?branch=master)](https://travis-ci.org/Justinzh1/HermioneRuby)

[http://www.peaceful-forest-88704.herokuapp.com](peaceful-forest-88704.herokuapp.com)

## Configuration
Include the following files `/.env` and `/client_secrets.json`

### .env keys include
```
BOX_CLIENT_ID=
BOX_CLIENT_SECRET=
YOUTUBE_CLIENT_ID=
YOUTUBE_CLIENT_SECRET=
YOUTUBE_API_SERVICE_NAME=Hermione
YOUTUBE_API_VERSION=v3
YOUTUBE_DEVELOPER_KEY=
GOOGLE_APPLICATION_CREDENTIALS=
```

### client_secret.json 
Downloaded from the Google API dashboard

## Setup
- `rails db:create`
- `rails db:migrate`
- `rails db:seed`
- `rails s`
