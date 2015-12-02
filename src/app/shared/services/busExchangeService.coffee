angular.module('transportPlannerApp').service("busExchangeService", ($http, $q) =>

  @cachedData = null
  @getBusExchanges = () =>

    deferBusExchange = $q.defer()
    $http.get('../data/interchangeInfo.json').success( (data) =>
      @cachedData = data
      deferBusExchange.resolve(data)
    )
    deferBusExchange.promise

  this

)
