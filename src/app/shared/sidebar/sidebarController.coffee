angular.module('transportPlannerApp').controller("sidebarController", ($scope) =>

  $scope.hideSidebar = () =>
    $('#sidebar-wrapper').toggle()
    return

)
