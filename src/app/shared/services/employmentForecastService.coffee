angular.module('app').service("employmentForecastService", ($http, $q) =>
  @getEmploymentForecast = () =>
    deferEmploymentForecast = $q.defer()
    $http.get('../data/emp_population.json').success( (data) =>
      deferEmploymentForecast.resolve(data)
    )

    deferEmploymentForecast.promise

  this
)
