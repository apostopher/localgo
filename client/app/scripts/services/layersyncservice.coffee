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
      if layer._id then specs._id = layer._id 
      specs

    pointToLayer = (feature, latlng) ->
      radius = feature.properties.radius || 100 # TODO :: hardcoding
      L.circle latlng, radius

    specsToLayer = (specs) ->
      options =
        style: (feature) -> specs.drawOptions
        pointToLayer: pointToLayer

      geoJson = L.geoJson specs.geoJSON, options
      layer = _.first geoJson.getLayers()
      layer.localgoOptions = specs.localgoOptions || {}
      layer._id = specs._id
      layer

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

      updateLayer: (layer, callback) ->
        layer_specs = layerToSpecs layer
        update_promise = $http.put "#{base_path}/update/#{layer_specs._id}", layer_specs
        update_promise.success (result) -> callback

      deleteLayer: (layer, callback) ->
        layer_specs = layerToSpecs layer
        delete_promise = $http.delete "#{base_path}/remove/#{layer_specs._id}"
        delete_promise.success (result) -> callback null, result
    }
