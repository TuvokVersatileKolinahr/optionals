###*
IndexController. Responsible for the index view.
###
app.controller "IndexController", ($scope, $route, $filter, UserData, GitHubUtils) ->
  $scope.whatsMyName = "Git issues"
  $scope.routename = $route.current.name
  $scope.items = UserData.users
  # use a model (or multiple) for this
  $scope.board = {}
  $scope.board.columns = [
    { name: 'Open issues', filter: 'open' },
    { name: 'Issues in progress', filter: 'progress' },
    { name: 'Closed issues', filter: 'closed' }
  ]
  $scope.board.issues = []

  $scope.issueSortOptions = {
    itemMoved: (event) ->
      console.log 'itemMoved'
      return true
    ,
    orderChanged: (event) ->
      console.log 'orderChanged'
      return true
  }

  $scope.repo = 'tuvokki/ipsaver'

  issueList = GitHubUtils.getIssues($scope.repo)
  issueList.then (list) ->
    # console.log "Fetched issues: ", list
    #angular.forEach($scope.board.columns, function(v,k){this.push(v.name)}, tst)
    angular.forEach $scope.board.columns,
      (v,k) ->
        v.issues = $filter('filter')(list, { state : v.filter })
        return
    console.log $scope.board
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
