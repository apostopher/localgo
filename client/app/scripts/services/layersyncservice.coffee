'use strict'

###*
 # @ngdoc service
 # @name locationdesignerApp.layerSyncService
 # @description
 # # layerSyncService
 # Factory in the locationdesignerApp.
###
angular.module('locationdesignerApp')
  .factory 'layerSyncService', ($http, $window) ->
    userid = $window.__localgoActiveUser__?.id
    base_path = "/layers/#{userid}"

    layerToSpecs = (layer) ->
      specs =
        drawOptions: layer.options
        localgoOptions: layer.localgoOptions || {}
        geoJSON: layer.toGeoJSON()

      if _.isFunction layer.getRadius
        if not _.has specs.geoJSON, 'properties'
          specs.geoJSON.properties = {}
        specs.geoJSON.properties.radius = layer.getRadius()

      specs

    specsToLayer = (specs) ->
      options =
        style: (feature) -> specs.drawOptions
        pointToLayer: (feature, latlng) ->
          radius = feature.properties.radius || 100 # TODO :: hardcoding
          L.circle latlng, radius

      layer = L.geoJson specs.geoJSON, options
      layer.localgoOptions = specs.localgoOptions || {}
      layer
      
    resolveResponse = (result, callback) ->
      if result
        callback null, result
      else
        callback new Error result.error

    # Public API here
    {
      getLayers: (callback) ->
        specs_promise = $http.get "#{base_path}/get"
        specs_promise.success (specs) ->
          layers = _.map specs, specsToLayer
          callback null, layers
        specs_promise.error (error) -> callback error

      addLayer: (layer, callback) ->
        layer_specs = layerToSpecs layer
        save_promise = $http.post "#{base_path}/add", layer_specs
        save_promise.success (results) ->
          result = results[0]
          if result?._id then layer._id = result._id
          callback null

      updateLayer: (layer_specs, callback) ->
        update_promise = $http.put "#{base_path}/update/#{layer_specs._id}", layer_specs
        update_promise.success (result) -> resolveResponse result, callback

      deleteLayers: (layers, callback) ->
        specs = _.map layers, layerToSpecs
        async.each specs, (spec, next) ->
          delete_promise = $http.delete "#{base_path}/delete/#{spec._id}"
          delete_promise.success (result) -> next result.error
        , callback
    }
