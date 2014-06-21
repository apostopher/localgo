'use strict'

###*
 # @ngdoc directive
 # @name locationdesignerApp.directive:sideBar
 # @description
 # # sideBar
###
angular.module('locationdesignerApp')
  .directive 'sideBar', ->
    templateUrl: '/views/sidebar.html'
    restrict: 'E'
    replace: true
    scope:
      layers: "="
    link: (scope, element, attrs) ->
      scope.shouldHide = ->
        if not _.isArray scope.layers then return true
        scope.layers.length is 0

      scope.isFenceMode = -> scope.layers?.length is 1
      scope.isGroupMode = -> scope.layers?.length > 1
