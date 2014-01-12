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
          stats  = Sidekiq::Stats.new
          resets = params.values.grep(/Reset (?!All)/)

          if resets.empty?
            stats.reset
          elsif stats.method(:reset).arity != -1
            raise StandardError, "Version mismatch. Please upgrade Sidekiq."
          else
            counts = resets.map {|r| r.split.last.downcase }
            stats.reset(*counts)
          end

          redirect root_path
        end
      end
    end
  end
end
