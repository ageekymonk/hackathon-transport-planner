angular.module('transportPlannerApp').service("busInfoService", ($http, $q) =>
  @getBusInfo = (busName) =>

    deferBusInfo = $q.defer()
    $http.get('../data/buses/'+busName+'.json').success( (data) =>
      deferBusInfo.resolve(data)
    )
    deferBusInfo.promise

  this
)
