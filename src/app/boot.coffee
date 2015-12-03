hex_to_rgba = (h,o) =>
  value = parseInt(h.slice(1),16);
  [(value >> 16) & 255, (value >> 8) & 255, (value) & 255, o]

trApp = angular.module('app', ['ngRoute'])

trApp.config(['$routeProvider', ($routeProvider) ->
  $routeProvider
    .when '/availability', {
      templateUrl: 'app/availability/availability.html'
      controller: 'routeAvailabilityController'
    }
    .when '/stop-optimizer', {
      templateUrl: 'app/stop-optimizer/stop_optimizer.html'
      controller: 'stopOptimizerController'
    }
    .otherwise { redirectTo: '/availability' }
])



# transportInsightApp.controller('busRouteController', ($scope, $http, busExchangeService, employmentForecastService, busInfoService) =>

#   # Initialize all variables
#   $scope.busInfo = {}
#   $scope.tripDate = moment("2015-12-01")
#   $scope.fromTime = "07:00:00"
#   $scope.toTime = "10:00:00"
#   $scope.datePickerStatus = { opened : false }
#   $scope.busRouteInfo = {}
#   $scope.direction = "1"
#   $scope.selBuses = []

#   # Set all ui
#   $scope.setDirection = (dirval) ->
#     $('.ui.buttons').find('.button.positive').removeClass('positive').siblings().addClass('positive')
#     $scope.direction = String(dirval)

#   $scope.datePickerOpen = (event) =>
#     $scope.datePickerStatus.opened = true

#   $('.ui.dropdown').dropdown()
#   #$('.ui.modal').modal('show')
#   $("#buses_dropdown").dropdown(
#     onRemove: (removedValue, removedText, $removedChoice) =>
#       $scope.selBuses = $scope.selBuses.filter (elem) => elem isnt removedValue
#       $scope.busExchangeMap.removeBusRoute(removedValue)
#       $scope.$apply()
#   )

#   $('.ui.accordion').accordion()
#   $('.menu .item').tab()

#   $('#triptime').daterangepicker({
#     timePicker: true,
#     timePicker12Hour: false,
#     timePickerIncrement: 1,
#     startDate: '2015-12-01 07:00:00',
#     endDate: '2015-12-01 10:00:00',
#     autoUpdateInput: true,
#     format: 'YYYY-MM-DD HH:mm:ss'
#     }, (start, end, label) ->
#       $scope.tripDate = start
#       $scope.fromTime = start.format('HH:mm:ss')
#       $scope.toTime = end.format('HH:mm:ss')
#       console.log(start, end, label);
#       $scope.$apply()
#   )

#   # Handle Interchange Selection
#   $scope.onInterchangeChange = (ichange) =>
#     $scope.interchange = ichange
#     $scope.busExchangeMap.moveToInterchange($scope.interchange)

#   # On Bus Selection
#   $scope.onBusSelect = (busName) =>
#     # $scope.removeOverlay "busRoute"
#     $scope.selBuses.push busName

#   $scope.$watchGroup(['selBuses.length', 'tripDate', 'fromTime', 'toTime', 'direction'], (newValues, oldValues, scope) ->
#     console.log(newValues)
#     if "All" in $scope.selBuses
#       $scope.selBuses = $scope.busExchange.getBuses($scope.interchange)

#     for bus in $scope.selBuses
#       if not $scope.busInfo[bus]?
#         $scope.busRouteInfo[bus] = {}
#         busInfoService.getBusInfo(bus).then((data) =>
#           $scope.busInfo[bus] = new Bus(bus, data)
#           if newValues.every((element) -> element?)
#             $scope.busRouteInfo[bus].trips = $scope.busInfo[bus].getTrips(newValues[1].day(), newValues[2], newValues[3], newValues[4])
#             $scope.busRouteInfo[bus].tripStats = $scope.busInfo[bus].getTripStats(newValues[1].day(), newValues[2], newValues[3], newValues[4])
#             console.log $scope.busRouteInfo[bus].tripStats
#             $scope.busExchangeMap.displayBusRoute(bus, $scope.busRouteInfo[bus].trips[0].stops)
#         )
#       else
#         if newValues.every((element) -> element?)
#           $scope.busRouteInfo[bus].trips = $scope.busInfo[bus].getTrips(newValues[1].day(), newValues[2], newValues[3], newValues[4])
#           $scope.busRouteInfo[bus].tripStats = $scope.busInfo[bus].getTripStats(newValues[1].day(), newValues[2], newValues[3], newValues[4])
#           $scope.busExchangeMap.displayBusRoute(bus, $scope.busRouteInfo[bus].trips[0].stops)

#   )

#   # Create a map and plot the cooordinates of parramatta
#   busExchangeService.getBusExchanges().then( (data) =>
#     $scope.busExchange = new BusExchange(data)
#     $scope.busExchangeMap = new BusExchangeMap($scope.busExchange)
#     $scope.map = $scope.busExchangeMap.initMap(null)
#     $scope.interchanges = $scope.busExchange.getInterchangeNames()
#     $scope.busExchangeMap.markInterchanges()
#   )


#   employmentForecastService.getEmploymentForecast().then((data) =>
#     $scope.employment_population_data = data
#   )

#   $scope.draw_employment_projection = () =>
#     data = $scope.employment_population_data
#     if $scope.map.getLayers().getArray().some((x) -> x.get("title") == "tz_layer_with_employment")
#       return

#     empdata_range = (parseFloat(data[tz]['employment']) for tz in Object.keys(data))
#     empdata_min = Math.min empdata_range...
#     empdata_max = Math.max empdata_range...
#     empdata_mean = (empdata_max - empdata_min)/2

#     color_fn = (v) =>
#       c_fn = d3.scale.linear()
#       .domain([empdata_min, empdata_mean, empdata_max])
#       .range(["#ffffcc", "#78c679", "#006837"])
#       .interpolate(d3.interpolateHcl)
#       c_fn = d3.scale.threshold().domain([0, 400.0, 1000.0, 2000.0, 3000.0])
#               .range(['#FFFFCC', '#D9F0A3', '#ADDD8E', '#78C679', '#41AB5D', '#238443'])
#       hex_to_rgba(c_fn(v), 0.4)


#     vectorLayer = new ol.layer.Vector({
#       title: 'tz_layer_with_employment',
#       source: new ol.source.Vector({
#         url: "../data/tz_nsw.geojson"
#         format: new ol.format.GeoJSON()
#         projection: 'EPSG:3857'
#       })
#       style: (feature, resolution) =>
#         emp_data = parseFloat(data[feature.C.TZ_CODE11]['employment'])
#         idx =  parseInt((emp_data - empdata_min) / ((empdata_max - empdata_min) / 5))
#         idx = if idx > 4 then 4 else idx

#         colors = ['rgba(255,255,204, 0.4)', 'rgba(217,240,163,0.4)', 'rgba(173,221,142,0.4)', 'rgba(65,171,93,0.4)', 'rgba(35,132,67,0.4)']
#         styles = [new ol.style.Style({ stroke: new ol.style.Stroke({color: 'blue', width: 1}), fill: new ol.style.Fill({color: color_fn(emp_data)}) })]
#     })

#     $scope.map.addLayer(vectorLayer)

#   $scope.draw_population_projection = () =>
#     data = $scope.employment_population_data
#     if $scope.map.getLayers().getArray().some((x) -> x.get("title") == "tz_layer_with_population")
#       return

#     empdata_range = (parseFloat(data[tz]['population'][1].replace(/,/,'')) for tz in Object.keys(data))
#     empdata_min = Math.min empdata_range...
#     empdata_max = Math.max empdata_range...

#     color_fn = (v) =>
#       c_fn = d3.scale.threshold().domain([0, 400.0, 1000.0, 2000.0, 3000.0])
#               .range(['#FFFFCC', '#D9F0A3', '#ADDD8E', '#78C679', '#41AB5D', '#238443'])
#       hex_to_rgba(c_fn(v), 0.4)

#     vectorLayer = new ol.layer.Vector({
#       title: 'tz_layer_with_population',
#       source: new ol.source.Vector({
#         url: "../data/tz_nsw.geojson"
#         format: new ol.format.GeoJSON()
#         projection: 'EPSG:3857'
#       })
#       style: (feature, resolution) =>
#         emp_data = parseFloat(data[feature.C.TZ_CODE11]['population'][1].replace(/,/,''))
#         idx =  parseInt((emp_data - empdata_min) / ((empdata_max - empdata_min) / 5))
#         idx = if idx > 4 then 4 else idx

#         colors = ['rgba(255,255,204, 0.4)', 'rgba(217,240,163,0.4)', 'rgba(173,221,142,0.4)', 'rgba(65,171,93,0.4)', 'rgba(35,132,67,0.4)']
#         styles = [new ol.style.Style({ stroke: new ol.style.Stroke({color: 'blue', width: 1}), fill: new ol.style.Fill({color: color_fn(emp_data)}) })]
#     })

#     $scope.map.addLayer(vectorLayer)

#   $scope.draw_bus_route = () =>
#     data = $scope.bus_info_data
#     busRouteFeatures = []

#     for stop_info in data['trips'][0]['stops']

#       temp = new ol.Feature({
#         geometry: new ol.geom.Circle(ol.proj.transform([parseFloat(stop_info['lon']), parseFloat(stop_info['lat'])], 'EPSG:4326', 'EPSG:3857'), 500),
#         name: stop_info['name'],
#         usage: if stop_info['usage']? then stop_info['usage'] else 0
#         avgtime: if data['trips'][0]['avg_travel_time']? then data['trips'][0]['avg_travel_time'] else 0
#       })

#       busRouteFeatures.push temp

#     popupElement = document.getElementById('popup')
#     popup = new ol.Overlay({
#       element: popupElement,
#       positioning: 'bottom-center',
#       stopEvent: false
#     })
#     $scope.map.addOverlay(popup)

#     $scope.map.on('click', (evt) =>
#       feature = $scope.map.forEachFeatureAtPixel(evt.pixel, (feature, layer) -> feature )
#       if (feature)
#         popup.setPosition(evt.coordinate);
#         $(popupElement).popover({
#           'placement': 'top',
#           'html': true,
#           'content': feature.get('name') + "(usage="+feature.get('usage')+")" + "(avgtime ="+feature.get('avgtime')+")"
#         })
#         $(popupElement).popover('show')
#       else
#         $(popupElement).popover('destroy')
#     )

#     busRouteSource = new ol.source.Vector({
#       features: busRouteFeatures
#     })

#     style = new ol.style.Style({
#       stroke: new ol.style.Stroke({color: 'red', width: 10}),
#       fill: new ol.style.Fill({color: 'rgba(255, 0, 0, 0.6)'})
#       image: new ol.style.Circle({radius: 7, fill: new ol.style.Fill({color: '#ff0000'})})
#     })

#     busRouteLayer = new ol.layer.Vector({
#       title: "busRoute"
#       source: busRouteSource
#       style: (feature, resolution) =>

#         c_fn = (v) =>
#           x = d3.scale.threshold().domain([0, 20.0, 100.0, 200.0, 2000.0])
#               .range(['#f7f4f9','#e7e1ef', '#e7298a', '#ce1256', '#91003f'])
#           hex_to_rgba(x(v), 0.2)

#         console.log(feature.get("usage"))
#         return [new ol.style.Style({
#           stroke: new ol.style.Stroke({color: 'red', width: 1}),
#           fill: new ol.style.Fill({color: c_fn(feature.get("usage"))})
#           image: new ol.style.Circle({radius: 5, stroke: new ol.style.Stroke({color: 'red'}), fill: new ol.style.Fill({color: c_fn(feature.get("usage"))})})
#         })]
#     })

#     $scope.map.addLayer(busRouteLayer)


#   # Remove any layer with name
#   $scope.removeOverlay = (name) =>
#     for layer in $scope.map.getLayers().getArray()
#       console.log(layer.get("title"))
#       if layer.get("title") ==  name
#         $scope.map.removeLayer(layer)


#   $scope.overlayChange = () =>
#     console.log $scope.overlayType

#     if $scope.overlayType == "employment"
#       $scope.removeOverlay "tz_layer_with_population"
#       $scope.draw_employment_projection()
#     else
#       $scope.removeOverlay "tz_layer_with_employment"
#       $scope.draw_population_projection()


# )
