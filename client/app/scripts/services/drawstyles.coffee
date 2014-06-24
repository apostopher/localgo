'use strict'

angular.module('locationdesignerApp')
  .factory 'drawstyles', () ->
    {
      defaultStyle:
        weight: 1
        color: "#000"
        fillOpacity: 0.7

      activeStyle:
        weight: 3
        fillOpacity: 1
    }
