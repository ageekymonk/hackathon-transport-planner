angular.module('app').service("busInfoService", ($http, $q) =>
  @getBusInfo = (busName) =>

    deferBusInfo = $q.defer()
    $http.get('../data/buses/'+busName+'.json').success( (data) =>
      deferBusInfo.resolve({busName: busName, output: data})
    )
    deferBusInfo.promise

  this
)
