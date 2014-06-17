"use strict"

passport         = require('passport')
FacebookStrategy = require('passport-facebook').Strategy
config           = require './config/config'
_                = require 'lodash'

class Facebook
  @toString: -> "facebook" # to add it as key in {}

  constructor: (@app, db) ->
    @collection = db.collection 'users'

  setup: ->
    @app.get '/auth/facebook', passport.authenticate 'facebook', {scope: config.facebook.scope}
    @app.get '/auth/facebook/callback', passport.authenticate 'facebook', { successRedirect: '/', failureRedirect: '/error' }

    @app.get '/auth/facebook/deauthorize', (req, res) ->
      signed_request = req.body?.signed_request
      if not signed_request then return res.send 200
      
      res.send 200

    passport.use new FacebookStrategy config.facebook.app, (accessToken, refreshToken, profile, done) =>
      id = profile.id
      doc =
        id: id
        accessToken: accessToken
        refreshToken: refreshToken
        name: profile.displayName
        provider: profile.provider
      
      @collection.update {id}, doc, {upsert: true}, (error) =>
        if error then return done error
        done null, doc

  getUser: (id, callback) -> @collection.findOne {id}, callback

module.exports = Facebook