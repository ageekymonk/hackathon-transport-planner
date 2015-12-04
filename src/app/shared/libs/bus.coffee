module.exports = class Bus
  constructor: (name, busData) ->
    @name = name
    @busData = busData
    @busUsageData = null

  getName: () ->
    @name

  setBusUsageData: (data) ->
    @busUsageData = data

  getStops: (tripId) ->
    for trip in @busData['trips']
      if tripId == trip.id
        return trip.stops

  getTrips: (day, start, end, direction) ->
    direction_str = direction
    sel_trips = []
    for trip in @busData['trips']
      #TODO: Handle multiple day trips

      if (trip.direction == direction_str) and
      (trip.start_time >= start) and
      (trip.start_time <= end) and
      (trip.end_time <= end) and
      (trip.operating_days[day] == "1")
         sel_trips.push trip

    sel_trips

  getTripUsageData: (trips) ->
    trip_stats = _.map(trips, (trip) =>
      {
        id: trip.id,
        data:  _.filter(@busUsageData, (elem) => elem.trip_id == trip.id)
      }
    )

    trip_stats

  getNumStopUsage: (stop) ->
    _.filter(@busUsageData, (elem) => elem.origin_stop_id == stop).length

  getTripUsageStats: (trips) ->
    trip_usage_data = @getTripUsageData(trips)
    trip_usage_stats = {}

    for trip_elem in trip_usage_data

      trip_usage_stats[trip_elem.id] = { 'Users' : trip_elem.data.length,
      'avg delay' : _.reduce(_.map(trip_elem.data, (x) -> parseInt(x.delay)), (total,v) ->
        total + v
      , 0)/trip_elem.data.length  }

    trip_usage_stats

  getTripStats: (day, start, end, direction) ->
    sel_trips = @getTrips(day, start, end, direction)
    sel_trips_usage = @getTripUsageData(sel_trips)
    sel_trips_stat = {}
    trip_duration = []
    num_stops = []
    for trip in sel_trips
      trip_time_taken = moment(trip.end_time, "HH:mm:ss") - moment(trip.start_time, "HH:mm:ss")
      if trip_time_taken < 0
        trip_time_taken = moment(trip.end_time, "HH:mm:ss").add(24, 'h') - moment(trip.start_time, "HH:mm:ss")
      trip_duration.push trip_time_taken/1000
      num_stops.push parseInt(trip.stops.length)

    sel_trips_stat['Min time'] = Math.min trip_duration...
    sel_trips_stat['Max time'] = Math.max trip_duration...
    sel_trips_stat['Avg time'] = parseInt(_.reduce(trip_duration, (n,m) -> n+m) / trip_duration.length)
    sel_trips_stat.trips = sel_trips.length
    sel_trips_stat['Users'] = _.reduce(_.map(sel_trips_usage, (x) -> x.data.length), (res, val) ->
      res + val
    , 0)

    sel_trips_stat

  getTripDuration: (day, start, end, direction) ->
    trips = @getTrips(day, start, end, direction)
    trip_duration = []
    for trip in trips
      trip_time_taken = moment(trip.end_time, "HH:mm:ss") - moment(trip.start_time, "HH:mm:ss")
      if trip_time_taken < 0
        trip_time_taken = moment(trip.end_time, "HH:mm:ss").add(24, 'h') - moment(trip.start_time, "HH:mm:ss")
      trip_duration.push trip_time_taken/1000

    trip_duration
