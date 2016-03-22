class Custom
    def Custom.configure(config, settings)
        # Set The VM Provider
        # ENV['VAGRANT_DEFAULT_PROVIDER'] = settings["provider"] ||= "virtualbox"

        # Configure Local Variable To Access Scripts From Remote Location
        scriptDir = File.dirname(__FILE__)

        # Check each project for after.sh script
        if settings.include? 'folders'
            settings["folders"].each do |folder|
                afterScriptPath = File.expand_path(folder["map"] + '/after.sh')

                if File.exists? afterScriptPath then
                    config.vm.provision "shell", inline: "echo afterScriptPath"
                    config.vm.provision "shell", path: afterScriptPath
                end

            end
        end

        # Setup XIP.IO
        settings["sites"].each do |site|
            config.vm.provision "shell" do |s|
                s.path = "setup-xip.io.sh"
                s.args = [site["map"]]
            end
        end

  end
end
