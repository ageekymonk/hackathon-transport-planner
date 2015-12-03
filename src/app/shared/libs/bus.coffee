module.exports = class Bus
  constructor: (name, busData) ->
    @name = name
    @busData = busData

  getName: () ->
    @name

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

  getTripStats: (day, start, end, direction) ->
    sel_trips = @getTrips(day, start, end, direction)
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
    sel_trips_stat['Avg time'] = _.reduce(trip_duration, (n,m) -> n+m) / trip_duration.length
    sel_trips_stat.trips = sel_trips.length
    # sel_trips_stat.stops = sel_trips[0].stops.length
    # sel_trips_stat.distance =  parseInt(sel_trips[0].stops[sel_trips[0].stops.length-1].distance)
    # sel_trips_stat['Min Stops'] = Math.min num_stops...
    # sel_trips_stat['Max Stops'] = Math.max num_stops...
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
