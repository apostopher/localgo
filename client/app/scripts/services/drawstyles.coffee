'use strict'

angular.module('locationdesignerApp')
  .factory 'drawstyles', () ->
    {
      newLayerStyle:
        weight: 3
        fillOpacity: 1
        color: "#000"
        fillColor: "#33F48A"

      defaultStyle:
        weight: 1
        fillOpacity: 0.7

      activeStyle:
        weight: 3
        fillOpacity: 1
    }
