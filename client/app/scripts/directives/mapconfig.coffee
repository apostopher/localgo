'use strict'

angular.module('locationdesignerApp')
  .directive 'mapconfig', () ->
    templateUrl: '/views/mapconfig.html'
    restrict: 'E'
    link: (scope, element, attrs) ->
      
