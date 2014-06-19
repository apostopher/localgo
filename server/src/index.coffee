"use strict"

http          = require 'http'
_             = require 'lodash'
express       = require 'express'
socketio      = require 'socket.io'
bodyParser    = require 'body-parser'
cookieParser  = require 'cookie-parser'
session       = require 'cookie-session'
engines       = require 'consolidate'
config        = require './config/config'
{MongoClient} = require 'mongodb'

passport      = require 'passport'
Facebook      = require './facebook'

RESTController = require './RESTController'

CLIENT_PATH = "#{__dirname}/../client/dist"
class LocalgoServer
  constructor: ->
    @app = express()
    @server = http.createServer @app
    @io  = socketio @server
    @app.use express.static CLIENT_PATH
    @app.engine 'html', engines.hogan
    @app.set 'views', CLIENT_PATH
    @app.set 'view engine', 'html'
    @app.use bodyParser()
    @app.use cookieParser()
    @app.use session {secret: 'localgo'}

  init: (callback) ->
    MongoClient.connect "mongodb://localhost:27017/localgo", (error, db) =>
      if error then return callback error
      @db = db
      @setupPassport()
      @facebook_client = new Facebook @app, @db
      @facebook_client.setup()
      @setupRoutes()
      callback null

  setupRoutes: ->
    @app.get '/', (req, res) -> res.render 'index'
    @app.get "/user_status.js", (req, res) => @sendActiveUser req, res

    _.each config.resources, (resource_name) =>
      controller = new RESTController @db, resource_name
      controller.set "end request", true
      controller.setupRoutes @app

    @app.get '*', (req, res) -> res.render 'index'

  setupPassport: ->
    @app.use passport.initialize()
    @app.use passport.session()
    passport.serializeUser (user, done) ->
      username = "#{user.provider}:#{user.id}"
      done null, username

    passport.deserializeUser (id, done) =>
      [provider, userid] = id.split ":"
      @facebook_client.getUser userid, (error, user) =>
        done error, user

  start: (callback) ->
    port = +process.argv[2] || config.port || 9090
    @server.listen port, () -> callback port

  sendActiveUser: (req, res) ->
    if not req.user then req.user = {}
    if process.env.NODE_ENV is 'production'
      user_data = _.pick req.user, ['id', 'name']
    else
      user_data = id: '165516', 'name': 'test user'
      
    body = "var __localgoActiveUser__ = #{JSON.stringify user_data};"
    res.setHeader 'Content-Type', 'text/javascript'
    res.setHeader 'Content-Length', body.length
    res.end body

if require.main is module
  server_instance = new LocalgoServer()
  server_instance.init (error) ->
    if error then return console.log error
    server_instance.start (port) -> console.log "listening on port #{port}."