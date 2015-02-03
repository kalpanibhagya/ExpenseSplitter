module EventHelper
  def add_participate_link(name)
    link_to_function name do |page|
      page.insert_html :bottom, :tbl_participates, :partial => 'participate', :object => Participate.new
    end
  end
end
