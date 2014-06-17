'use strict'

###*
 # @ngdoc service
 # @name locationdesignerApp.layerSyncService
 # @description
 # # layerSyncService
 # Factory in the locationdesignerApp.
###
angular.module('locationdesignerApp')
  .factory 'layerSyncService', ($http) ->
    base_path = "/layers/rahul"

    layerToSpec = (layer) -> layer.specs
    specToLayer = (spec) ->
      
    resolveResponse = (result, callback) ->
      if result.status >= 0
        callback null
      else
        callback new Error result.error

    # Public API here
    {
      getLayers: (callback) ->
        specs_promise = $http.get "#{base_path}/get"
        specs_promise.success (specs) ->
          layers = _.map specs, specToLayer
          callback null, layers
        specs_promise.error (error) -> callback error

      addLayer: (layer, callback) ->
        layer_specs = layerToSpec layer
        save_promise = $http.post "#{base_path}/add/#{layer_specs._id}", layer_specs
        save_promise.success (result) -> resolveResponse result, callback

      updateLayer: (layer_specs, callback) ->
        update_promise = $http.put "#{base_path}/update/#{layer_specs._id}", layer_specs
        update_promise.success (result) -> resolveResponse result, callback

      deleteLayers: (layers, callback) ->
        specs = _.map layers, layerToSpec
        async.each specs, (spec, next) ->
          delete_promise = $http.delete "#{base_path}/delete/#{spec._id}"
          delete_promise.success (result) -> next result.error
        , callback
    }
