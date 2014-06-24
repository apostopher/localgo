'use strict'

###*
 # @ngdoc directive
 # @name locationdesignerApp.directive:sideBar
 # @description
 # # sideBar
###
angular.module('locationdesignerApp')
  .directive 'sideBar', () ->
    templateUrl: '/views/sidebar.html'
    restrict: 'E'
    replace: true
    scope:
      fences: "=activelayers"
    link: (scope, element, attrs) ->
      scope.shouldHide = ->
        if not _.isArray scope.fences then return true
        scope.fences.length is 0

      scope.isFenceMode = -> scope.fences?.length is 1
      scope.isGroupMode = -> scope.fences?.length > 1
