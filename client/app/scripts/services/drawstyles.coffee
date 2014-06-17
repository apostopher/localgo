'use strict'

angular.module('locationdesignerApp')
  .factory 'drawstyles', () ->
    {
      defaultStyle:
        weight: 1
        color: "#000"
        fillColor: "#C7C7CC"
        fillOpacity: 0.9
        opacity: 1

      activeStyle:
        weight: 2
        color: "#000"
        fillColor: "#EF4DB6"
        fillOpacity: 0.9
        opacity : 1
    }
