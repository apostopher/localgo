'use strict'

describe 'Directive: sideBar', ->

  # load the directive's module
  beforeEach module 'locationdesignerApp'

  scope = {}

  beforeEach inject ($controller, $rootScope) ->
    scope = $rootScope.$new()

  it 'should make hidden element visible', inject ($compile) ->
    element = angular.element '<side-bar></side-bar>'
    element = $compile(element) scope
    expect(element.text()).toBe 'this is the sideBar directive'
