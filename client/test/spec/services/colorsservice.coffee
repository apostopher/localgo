'use strict'

describe 'Service: colorsService', ->

  # load the service's module
  beforeEach module 'locationdesignerApp'

  # instantiate service
  colorsService = {}
  beforeEach inject (_colorsService_) ->
    colorsService = _colorsService_

  it 'should do something', ->
    expect(!!colorsService).toBe true
