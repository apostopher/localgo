'use strict'

angular.module('locationdesignerApp')
  .controller 'MainCtrl', ($scope, mapoptions, leafletData, drawoptions, drawstyles, layerSyncService) ->
    mapoptions $scope
    leafletData.getMap().then (map) ->
      $scope.map = map
      $scope.addControls map
      $scope.attachEvents map
      $scope.getLayers()

    $scope.active_layers = []
    $scope.clicked_layer = undefined

    $scope.$watch 'active_layers', (new_layers, old_layers) ->
      for layer in old_layers
        layer.setStyle drawstyles.defaultStyle

    $scope.addControls = (map) ->
      drawn_items = new L.FeatureGroup()
      $scope.drawn_items = drawn_items #Save this layer
      map.addLayer drawn_items
      options = drawoptions drawn_items
      map.addControl new L.Control.Draw options

    $scope.attachEvents = (map) ->
      map.on 'click', (event) ->
        $scope.$apply ->
          $scope.clicked_layer = undefined
          $scope.active_layers = []

      map.on 'draw:created', (event) ->
        $scope.$apply -> $scope.addLayer event.layer

      map.on 'draw:deleted', (event) ->
        $scope.$apply -> $scope.removeLayers event.layers

      map.on 'draw:edited', (event) ->
        $scope.$apply -> $scope.updateLayers event.layers
      
    $scope.removeLayers = (layers) -> layers.eachLayer (layer) ->
      _.remove $scope.active_layers, (active_layer) -> layer is active_layer
      if $scope.clicked_layer is layer then $scope.clicked_layer = undefined
      layerSyncService.deleteLayer layer, (error, result) -> console.log result

    $scope.updateLayers = (layers) -> layers.eachLayer (layer) ->
      layerSyncService.updateLayer layer, (error, result) -> console.log result

    $scope.getLayers = ->
      layerSyncService.getLayers (error, layers) ->
        if error then return console.log error
        _.each layers, (layer) -> $scope.drawLayer layer, false

    onLayerClick = (event) ->
      $scope.$apply ->
        # SHIFT key is used to group layers
        fresh_start = not event.originalEvent.shiftKey
        layer = event.target
        layer.setStyle drawstyles.activeStyle
        $scope.addActive layer, fresh_start

    $scope.drawLayer = (layer, active = true) ->
      if active
        layer.setStyle drawstyles.activeStyle
        $scope.addActive layer
      layer.on 'click', onLayerClick
      $scope.drawn_items.addLayer layer

    $scope.addLayer = (layer) ->
      $scope.drawLayer layer
      layerSyncService.addLayer layer, (error) ->
        if error then console.log error

    $scope.addActive = (layer, fresh_start = true) ->
      $scope.clicked_layer = layer
      if -1 is _.indexOf $scope.active_layers, layer
        if fresh_start then $scope.active_layers = []
        $scope.active_layers.push layer
