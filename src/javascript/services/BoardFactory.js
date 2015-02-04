app.factory('BoardUtils', function() {
  var boardUtils = {};

  var board = {};
  board.issues = [];
  board.columns = [
    {
      name: 'Open issues',
      filter: 'open'
    }, {
      name: 'Issues in progress',
      filter: 'progress'
    }, {
      name: 'Ready for testing',
      filter: 'testing'
    }, {
      name: 'Closed issues',
      filter: 'closed'
    }
  ];
  boardUtils.board = board;
  boardUtils.issueSortOptions = {
    itemMoved: function(event) {
      console.log('itemMoved', event);
      return true;
    },
    orderChanged: function(event) {
      console.log('orderChanged', event);
      return true;
    }
  };
  return boardUtils;
});
