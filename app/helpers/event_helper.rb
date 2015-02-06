module EventHelper
  def get_participant_id(participant)
    "#{participant.user.id}"
  end

  def format_amount(float)
    number_with_precision(float, precision: 2)
  end
end
