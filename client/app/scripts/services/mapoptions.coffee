'use strict'

angular.module('locationdesignerApp')
  .factory 'mapoptions', () ->

    # Configuration
    config =
      defaults:
        attributionControl: false    
      tiles:
        url: "https://{s}.tiles.mapbox.com/v3/apostopher.hk2178n7/{z}/{x}/{y}.png"
      center:
        autoDiscover: true
        zoom: 12

    return (scope_object) -> _.assign scope_object, config