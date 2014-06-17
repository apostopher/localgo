'use strict'

describe 'Controller: MainCtrl', () ->

  # load the controller's module
  beforeEach module 'locationdesignerApp'

  MainCtrl = {}
  scope = {}

  # Initialize the controller and a mock scope
  beforeEach inject ($controller, $rootScope) ->
    scope = $rootScope.$new()
    MainCtrl = $controller 'MainCtrl', {
      $scope: scope
    }

  it 'should start with empty list of active_layers', () ->
    expect(scope.active_layers.length).toBe 0
