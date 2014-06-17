'use strict'
angular.module('locationdesignerApp')
  .directive 'movable', () ->
    restrict: 'E'
    template: '<div></div>'
    replace: true
    scope:
      move: "&"
    link: (scope, element, attrs) ->
      header = element.parent().children '.carddrag'
      config =
        type:"x,y", 
        edgeResistance:0.5, 
        bounds:"#main",
        trigger: header,
        onDrag: scope.move

      Draggable.create element.parent(), config

