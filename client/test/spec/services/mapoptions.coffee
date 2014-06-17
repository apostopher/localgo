'use strict'

describe 'Service: mapoptions', () ->

  # load the service's module
  beforeEach module 'locationdesignerApp'

  # instantiate service
  mapoptions = {}
  beforeEach inject (_mapoptions_) ->
    mapoptions = _mapoptions_

  it 'should do something', () ->
    expect(!!mapoptions).toBe true
