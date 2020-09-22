class UrlMaker
  include Rails.application.routes.url_helpers

  def initialize(named_route, *object_ids)
    @named_route = named_route
    @object_ids = object_ids
  end

  def full_url
    Rails.application.routes.url_helpers.send("#{@named_route}_url", *@object_ids, only_path: false, host: "www.plantasusual.com", protocol: 'https')
  end
end
