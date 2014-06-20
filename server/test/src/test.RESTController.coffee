"use strict"

_         =  require 'lodash'
async     = require 'async'
expect    = (require 'chai').expect

{MongoClient} = require 'mongodb'

RESTController = require '../RESTController'

describe 'RESTController', ->
  database = null
  restController = null

  before (done) ->
    MongoClient.connect "mongodb://localhost:27017/localgotest", (error, db) ->
      if error then return done error
      database = db
      restController = new RESTController database, 'smartphones'
      done()

  describe 'operations', ->
    inserted_records = []
    it 'should add the records correctly', (done) ->
      async.eachSeries [1..10], (num, callback) ->
        res = {}
        req =
          params:
            owner: 'apos'
          body:
            id: num
            name: "iphone#{num}"
        restController.add req, res, (error) ->
          if error then return callback error
          expect(res.result[0].name).to.equal req.body.name
          inserted_records.push res.result[0]._id
          callback()
      , done

    it 'should get the records correctly', (done) ->
      res = {}
      req =
        params:
          owner: 'apos'
      restController.get req, res, (error) ->
        if error then return done error
        expect(res.result.length).to.equal 10
        done()

    it 'should get the a single record correctly', (done) ->
      res = {}
      req =
        params:
          id: inserted_records[0]
          owner: 'apos'
      restController.getOne req, res, (error) ->
        if error then return done error
        expect(res.result).to.be.ok
        done()

    it 'should update a single record correctly', (done) ->
      res = {}
      req =
        params:
          id: inserted_records[0]
          owner: 'apos'
        body:
          name: 'samsung'
      restController.update req, res, (error) ->
        if error then return done error
        expect(res.result.updated).to.equal 1
        done()

    it 'should remove the records correctly', (done) ->
      async.eachSeries [0..9], (num, callback) ->
        res = {}
        req =
          params:
            owner: 'apos'
            id: inserted_records[num]
        restController.remove req, res, (error) ->
          if error then return callback error
          expect(res.result.removed).to.equal 1
          callback()
      , done