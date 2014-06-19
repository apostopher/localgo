'use strict'

angular.module('locationdesignerApp')
  .controller 'MainCtrl', ($scope, mapoptions, leafletData, drawoptions, drawstyles, layerSyncService) ->
    mapoptions $scope
    leafletData.getMap().then (map) ->
      $scope.map = map
      $scope.addControls map
      $scope.attachEvents map

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
        layer = event.layer
        $scope.addLayer layer
        $scope.$apply ->
          $scope.drawn_items.addLayer layer
          layerSyncService.addLayer layer, (error) -> console.log layer._id

      map.on 'draw:deleted', (event) ->
        layers = event.layers
        $scope.removeLayers layers
      
    removeLayer = (layer) ->
      $scope.$apply ->
        _.remove $scope.active_layers, (active_layer) -> layer is active_layer
        if $scope.clicked_layer is layer then $scope.clicked_layer = undefined

    $scope.removeLayers = (layers) -> layers.eachLayer removeLayer  

    onLayerClick = (event) ->
      # SHIFT key is used to group layers
      fresh_start = not event.originalEvent.shiftKey
      layer = event.target
      layer.setStyle drawstyles.activeStyle
      $scope.addActive layer, fresh_start
      true

    $scope.addLayer = (layer) ->
      layer.setStyle drawstyles.activeStyle
      $scope.addActive layer
      layer.on 'click', onLayerClick

    $scope.addActive = (layer, fresh_start = true) ->
      $scope.clicked_layer = layer
      if -1 is _.indexOf $scope.active_layers, layer
        if fresh_start then $scope.active_layers = []
        $scope.$apply -> $scope.active_layers.push layer
