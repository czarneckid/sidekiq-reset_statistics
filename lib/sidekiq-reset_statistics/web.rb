module Sidekiq
  module ResetStatistics
    module Web
      def self.registered(app)
        app.get "/reset-statistics" do
          web_dir = File.expand_path("../../../web", __FILE__)
          view_path = File.join(web_dir, "views", "reset_statistics.erb")
          template = File.read(view_path)
          render :erb, template
        end

        app.post "/reset-statistics" do
          Sidekiq::Stats.new.reset
          redirect root_path
        end
      end
    end
  end
end