# hotel-locator-server
Server for a hotel locator

## Instructions
- Node 4.6.1 (this is the latest supported by heroku)

### Run the application
- Install coffeescript
- Execute the following commands to install the dependencies and run the application.
```
$ npm install
$ coffee server.coffee
```

### Architectural decisions
- The application was split in 2 repository, since heroku couldn't recognize subfolders.

### Would do, if had more time
- Cache the user location. The browser takes a bit of time to return it.
- Cache the list of hotels result, considering the user wouldn’t change their location so quickly.
- The controller folder could be a separated project, considering it could be used for any other company’s team.
- Would add a testing module.

### Faced issues
- Deploying in heroku using a 6.9.1 version
- Deploying heroku using subfolder
