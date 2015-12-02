d3 = require('d3')
turf = require('turf')

hex_to_rgba = (h,o) =>
  value = parseInt(h.slice(1),16);
  [(value >> 16) & 255, (value >> 8) & 255, (value) & 255, o]

module.exports = class BusExchangeMap
  constructor: (busExchangeInfo) ->
    @busExchangeInfo = busExchangeInfo
    @busInfo = {}

  initMap: (map) ->
    if map == null
      @map = new ol.Map({
        target: 'map'
        layers: [new ol.layer.Tile(source: new ol.source.OSM )]
        view: new ol.View({center: ol.proj.transform([151.0032968,-33.8176967], 'EPSG:4326', 'EPSG:3857'), zoom: 14})
      })
    else
      @map = map

    @map

  addBus: (busInfo) ->
    @busInfo[busInfo.getName()] = busInfo

  markInterchanges: () ->
    iconStyle = new ol.style.Style(
        image: new ol.style.Icon(
            anchor: [0.5, 46],
            anchorXUnits: 'fraction',
            anchorYUnits: 'pixels',
            opacity: 0.75,
            src: '../images/marker.png'
        )
    )

    exchangeFeatures = []

    for stop in @busExchangeInfo.getStops()

      temp = new ol.Feature({
        geometry: new ol.geom.Point(ol.proj.transform([parseFloat(stop['long']), parseFloat(stop['lat'])], 'EPSG:4326', 'EPSG:3857')),
        name: stop.id,
      })
      temp.setStyle(iconStyle)
      exchangeFeatures.push temp

    exchangeSource = new ol.source.Vector({
      features: exchangeFeatures
    })

    exchangeLayer = new ol.layer.Vector({
      source: exchangeSource
    })

    @map.addLayer(exchangeLayer)

  moveToInterchange: (ichange) ->
    [lat, lon] = @busExchangeInfo.getInterchangeFirstLatLong(ichange)
    @map.getView().setCenter(ol.proj.transform([lon, lat], 'EPSG:4326', 'EPSG:3857'))

  removeBusRoute: (bus) ->
    for layer in @map.getLayers().getArray()
      if layer.get("title") ==  bus + "_route_coverage"
        @map.removeLayer(layer)

  displayBusRoute: (bus, stops) ->

    busRouteFeatures = []
    turf_points = []
    for stop_info in stops
      turf_points.push turf.buffer(turf.point([parseFloat(stop_info['lon']), parseFloat(stop_info['lat'])], { name: stop_info['name'] }), 500, 'meters').features[0]

      temp = new ol.Feature({
        geometry: new ol.geom.Circle(ol.proj.transform([parseFloat(stop_info['lon']), parseFloat(stop_info['lat'])], 'EPSG:4326', 'EPSG:3857'), 500),
        name: stop_info['name']
      })

      busRouteFeatures.push temp

    busRouteSource = new ol.source.Vector({
      features: busRouteFeatures
    })

    style = new ol.style.Style({
      stroke: new ol.style.Stroke({color: 'red', width: 10}),
      fill: new ol.style.Fill({color: 'rgba(255, 0, 0, 0.6)'})
      image: new ol.style.Circle({radius: 7, fill: new ol.style.Fill({color: '#ff0000'})})
    })

    turf_layer = new ol.layer.Vector({
      title: bus + '_route_coverage',
      source: new ol.source.Vector({
        features: (new ol.format.GeoJSON()).readFeatures(turf.merge(turf.featurecollection(turf_points)), {featureProjection: 'EPSG:3857'})
        format: new ol.format.GeoJSON()

      })
      style: [
          new ol.style.Style({
            stroke: new ol.style.Stroke({color: 'red', width: 1}),
            fill: new ol.style.Fill({color: hex_to_rgba('#91003f',0.2)})
            image: new ol.style.Circle({
              stroke: new ol.style.Stroke({
                color: 'white'
              }),
              fill: new ol.style.Fill({
                color: '#1f6b75'
              }),
              radius: 5
            })
          })
        ]

    })

    busRouteLayer = new ol.layer.Vector({
      title: "busRoute"
      source: busRouteSource
      style: (feature, resolution) =>

        c_fn = (v) =>
          x = d3.scale.threshold().domain([0, 20.0, 100.0, 200.0, 2000.0])
              .range(['#f7f4f9','#e7e1ef', '#e7298a', '#ce1256', '#91003f'])
          hex_to_rgba(x(v), 0.2)

        return [new ol.style.Style({
          stroke: new ol.style.Stroke({color: 'red', width: 1}),
          fill: new ol.style.Fill({color: c_fn(100)})
          image: new ol.style.Circle({radius: 5, stroke: new ol.style.Stroke({color: 'red'}), fill: new ol.style.Fill({color: c_fn(100)})})
        })]
    })

    #@map.addLayer(busRouteLayer)
    @map.addLayer(turf_layer)
