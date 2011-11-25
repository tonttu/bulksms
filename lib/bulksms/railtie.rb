module Bulksms

  class Railtie < ::Rails::Railtie

    config.before_configuration do
      config.bulksms = Bulksms.config
    end

  end

end
