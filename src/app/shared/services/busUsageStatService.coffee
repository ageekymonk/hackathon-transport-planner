angular.module('app').service("busUsageStatService", ($http, $q) =>
  @getBusUsageStats = (busName) =>

    deferBusInfo = $q.defer()
    d3.csv('../data/buses_opal_stats/'+busName+'.csv', (response) =>
      deferBusInfo.resolve({busName: busName, output: response })
    )
    deferBusInfo.promise

  this
)
