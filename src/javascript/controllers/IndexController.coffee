###*
IndexController. Responsible for the index view.
###
app.controller "IndexController", ($scope, $route, UserData) ->
  $scope.whatsMyName = "Testable content"
  $scope.routename = $route.current.name
  $scope.items = UserData.users
  $scope.dragControlListeners = {
    #override to determine drag is allowed or not. default is true.
    accept: (sourceItemHandleScope, destSortableScope) -> return boolean
    itemMoved: (event) -> { },
    orderChanged: (event) -> { },
    containment: '#board' #optional param.
  }
  return
