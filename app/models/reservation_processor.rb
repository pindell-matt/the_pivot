class ReservationProcessor

  def initialize(cart, user)
    @cart = cart
    @user = user
  end

  def create_trip
    reservations = process_cart
    trip = Trip.create(user_id: @user.id)
    trip.reservations << reservations
  end

  def process_cart
    reservations = create_reservations
    reservations.each do |reservation|
      create_and_assign_days(reservation)
    end
  end

  def create_reservations
    @cart.each_pair.map do |home_id, data|
      reservation = Reservation.create(
        home_id:   home_id,
        user_id:   @user.id,
        check_in:  data['check_in'],
        check_out: data['check_out'],
      )
    end
  end

  def create_and_assign_days(reservation)
    if reservation.check_in == reservation.check_out
      Day.create(date: reservation.check_in)
    else
      date = reservation.check_in
      until date == reservation.check_out
        Day.create(date: date)
        date = date.next
      end
    end
    Day.book(reservation)
  end

end
