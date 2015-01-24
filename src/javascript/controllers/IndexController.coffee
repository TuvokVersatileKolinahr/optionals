###*
IndexController. Responsible for the index view.
###
app.controller "IndexController", ($scope, $route, UserData, GitHubUtils) ->
  $scope.whatsMyName = "Testable content"
  $scope.routename = $route.current.name
  $scope.items = UserData.users
  $scope.issues = []
  $scope.dragControlListeners = {
    #override to determine drag is allowed or not. default is true.
    accept: (sourceItemHandleScope, destSortableScope) -> return boolean
    itemMoved: (event) -> { 
      console.log "heheh"
    },
    orderChanged: (event) -> { 
      console.log "heheh"
    },
    containment: '#board' #optional param.
  }

  $scope.repo = 'tuvokki/ipsaver'

  issueList = GitHubUtils.getIssues($scope.repo)
  issueList.then (list) ->
    console.log "Fetched issues: ", list
    $scope.issues = list
    $scope.$apply()
    return

  $scope.updateList = ->
    issueList = GitHubUtils.getIssues($scope.repo)
    issueList.then (list) ->
      console.log list
      $scope.issues = list
      $scope.$apply()
      return

  return
