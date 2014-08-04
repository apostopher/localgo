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
      scope.$watchCollection 'fences', (new_fences, old_fences) ->
        scope.updateActive()

      scope.updateActive = ->
        colors = _.uniq _.map scope.fences, (fence) -> fence.options.fillColor
        if colors.length is 1
          scope.active_color = _.first colors
        else
          scope.active_color = undefined

      scope.setColor = (event, color) ->
        event.preventDefault()
        scope.active_color = color
        _.each scope.fences, (fence) ->
          fence.setStyle {fillColor: color}
          layerSyncService.updateLayer fence, (error, result) -> console.log result

      scope.isActive = (color) -> color is scope.active_color
