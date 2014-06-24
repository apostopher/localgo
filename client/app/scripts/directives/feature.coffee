'use strict'

angular.module('locationdesignerApp')
  .directive 'feature', ->
    templateUrl: "/views/feature.html"
    restrict: 'E'
    replace: true
    transclude: true
    scope:
      heading: "@"
    link: (scope, element, attrs) ->
      scope.hide = true
      scope.sectionOpen = true
      scope.toggleActionButton = (state) -> scope.hide = state
      scope.toggleState = (event) ->
        event.preventDefault()
        scope.sectionOpen = not scope.sectionOpen
        
      scope.getMenuText = ->
        if scope.sectionOpen then return "hide"
        return "show"
