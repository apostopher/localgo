'use strict'

angular.module('locationdesignerApp')
  .factory 'drawstyles', () ->
    {
      defaultStyle:
        weight: 1
        color: "#000"
        fillColor: "#C7C7CC"
        fillOpacity: 0.7
        opacity: 1

      activeStyle:
        weight: 3
        color: "#000"
        fillOpacity: 1
        opacity : 1
    }
