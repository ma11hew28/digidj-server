class Track
  attr_accessor :track_id, :dollar_amount
  
  def initialize(track_id, dollar_amount)
    @track_id = track_id
    @dollar_amount = dollar_amount
  end
  
  def to_hash
    {track_id: @track_id, dollar_amount: @dollar_amount}
  end
  
  def ==(other)
      other.track_id == @track_id && other.dollar_amount == @dollar_amount
  end
end
