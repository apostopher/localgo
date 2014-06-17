'use strict'

describe 'Service: layerSyncService', ->

  # load the service's module
  beforeEach module 'locationdesignerApp'

  # instantiate service
  layerSyncService = {}
  beforeEach inject (_layerSyncService_) ->
    layerSyncService = _layerSyncService_

  it 'should do something', ->
    expect(!!layerSyncService).toBe true
