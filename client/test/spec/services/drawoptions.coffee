'use strict'

describe 'Service: drawoptions', () ->

  # load the service's module
  beforeEach module 'locationdesignerApp'

  # instantiate service
  drawoptions = {}
  beforeEach inject (_drawoptions_) ->
    drawoptions = _drawoptions_

  it 'should do something', () ->
    expect(!!drawoptions).toBe true
