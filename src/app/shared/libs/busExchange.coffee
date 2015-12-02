module.exports = class BusExchange
  constructor: (exchangeData) ->
    @exchangeData = exchangeData

  getInterchangeNames: () ->
    Object.keys @exchangeData

  getStops: () ->
    stops = []
    for ich in @getInterchangeNames()
      for stop in @exchangeData[ich]['stops']
        stops.push stop
    stops

  getBuses: (ich) ->
    if ich?
      (bus for bus in @exchangeData[ich]['buses']).sort()

  getInterchangeFirstLatLong: (ichange) ->
    [parseFloat(@exchangeData[ichange]['stops'][0].lat), parseFloat(@exchangeData[ichange]['stops'][0].long)]
