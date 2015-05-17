class MuranoApp < Roda

  plugin :render,
    engine: "html.erb",
    views: File.expand_path("../views", __FILE__)

  route do |r|
    r.root do
      render "home"
    end

    r.get "snapshot" do
      render "snapshot"
    end

    r.get "spending" do
      render "spending"
    end
  end

end
