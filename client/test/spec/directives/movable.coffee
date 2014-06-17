'use strict'

describe 'Directive: movable', () ->

  # load the directive's module
  beforeEach module 'locationdesignerApp'

  scope = {}

  beforeEach inject ($controller, $rootScope) ->
    scope = $rootScope.$new()

  it 'should make hidden element visible', inject ($compile) ->
    element = angular.element '<movable></movable>'
    element = $compile(element) scope
    expect(element.text()).toBe 'this is the movable directive'
