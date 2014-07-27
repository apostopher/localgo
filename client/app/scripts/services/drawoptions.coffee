'use strict'

angular.module('locationdesignerApp')
  .factory 'drawoptions', (drawstyles) ->
    return (drawn_items) ->
      {
        draw:
          polygon: false,
          marker: false,
          rectangle : false,
          polyline : false,
          circle :
            shapeOptions: drawstyles.newLayerStyle
        edit:
          featureGroup: drawn_items
          edit:
            selectedPathOptions : drawstyles.newLayerStyle
      }