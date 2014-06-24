'use strict'

###*
 # @ngdoc directive
 # @name locationdesignerApp.directive:colorPalette
 # @description
 # # colorPalette
###
angular.module('locationdesignerApp')
  .directive 'colorPalette', (colorsService, layerSyncService) ->
    templateUrl: '/views/colorpalette.html'
    restrict: 'E'
    replace: true
    scope:
      fences: "="
    link: (scope, element, attrs) ->
      scope.colors = colorsService
      colors = _.uniq _.map scope.fences, (fence) -> fence.options.fillColor
      if colors.length is 1
        scope.active_color = _.first colors
      else
        scope.active_color = undefined
        
      scope.setColor = (event, hex_value) ->
        event.preventDefault()
        _.each scope.fences, (fence) ->
          fence.setStyle {fillColor: hex_value}
          layerSyncService.updateLayer fence, (error, result) -> console.log result
