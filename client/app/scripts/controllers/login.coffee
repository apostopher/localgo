'use strict'

###*
 # @ngdoc function
 # @name locationdesignerApp.controller:LoginCtrl
 # @description
 # # LoginCtrl
 # Controller of the locationdesignerApp
###
angular.module('locationdesignerApp')
  .controller 'LoginCtrl', ($scope, $window) ->
    heading_color = "#000"
    setNewColor = _.throttle () ->
      heading_color = randomColor luminosity: 'dark'
    , 1000

    $scope.loginOauth = (provider) ->
      $window.location.href = '/auth/' + provider

    $scope.logoutOauth = (provider) ->
      $window.location.href = '/logout/' + provider

    $scope.activeUser = $window.__localgoActiveUser__?.name

    $scope.getFunColor = () ->
      setNewColor()
      color: heading_color
