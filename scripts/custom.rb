class Custom
    def Custom.configure(config, settings)
        # Set The VM Provider
        # ENV['VAGRANT_DEFAULT_PROVIDER'] = settings["provider"] ||= "virtualbox"

        # Configure Local Variable To Access Scripts From Remote Location
        scriptDir = File.dirname(__FILE__)

        # Check each project for after.sh script
        config.vm.provision "shell", inline: "echo 'Check each project for after.sh script'"
        if settings.include? 'folders'
            settings["folders"].each do |folder|
                afterScriptPath = File.expand_path(folder["map"] + '/after.sh')
                if File.exists? afterScriptPath then
                    config.vm.provision "shell", inline: "echo afterScriptPath"
                    config.vm.provision "shell", path: afterScriptPath, args:[folder["to"]]
                end
            end
        end

        
        # Loop through site folders for extra setup
        config.vm.provision "shell", inline: "echo 'Loop through site folders for extra setup'"
        if settings.include? 'folders'
            settings["folders"].each do |folder|
                
                # Check each project for database dump
                config.vm.provision "shell", inline: "echo 'Import database dump files'"
                if folder.include? 'database'

                    dump = File.expand_path(folder["map"] + '/.database/db-latest.sql.zip')
                    if File.exists? dump then
                        dbfile = '/.database/db-latest.sql.zip';
                    end

                    dump = File.expand_path(folder["map"] + '/.database/db-latest.sql')
                    if File.exists? dump then
                        dbfile = '/.database/db-latest.sql';
                    end
                    
                    unless dbfile.nil? || dbfile == 0
                        dump = File.expand_path(folder["to"] + dbfile)
                        config.vm.provision "shell" do |s|
                            s.path = "../scripts/import-db.sh"
                            s.args = [folder["database"], dump, dbfile]
                        end
                    end



                end

                # Check each project for shell script
                config.vm.provision "shell", inline: "echo 'Check each project for shell script'"
                projectScript = '/.homestead.sh';
                projectScriptPath = File.expand_path(folder["map"] + projectScript)

                if File.exists? projectScriptPath then
                    config.vm.provision "shell", path: projectScriptPath
                end

            end
        end

        # Setup XIP.IO
        config.vm.provision "shell", inline: "echo 'Setup XIP.IO'"
        settings["sites"].each do |site|
            config.vm.provision "shell" do |s|
                s.path = "../scripts/setup-xip.io.sh"
                s.args = [site["map"]]
            end
        end
        config.vm.provision "shell", inline: "service nginx restart"
        

  end
end
