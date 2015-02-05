module EventHelper
  def get_participant_id(participant)
    "#{participant.user.id}"
  end
end
