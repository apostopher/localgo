'use strict'

describe 'Service: drawstyles', () ->

  # load the service's module
  beforeEach module 'locationdesignerApp'

  # instantiate service
  drawstyles = {}
  beforeEach inject (_drawstyles_) ->
    drawstyles = _drawstyles_

  it 'should do something', () ->
    expect(!!drawstyles).toBe true
