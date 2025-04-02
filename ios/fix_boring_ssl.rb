#!/usr/bin/env ruby

require 'xcodeproj'

# Chemin du projet Pods
project_path = 'Pods/Pods.xcodeproj'
project = Xcodeproj::Project.open(project_path)

puts "Projet ouvert: #{project_path}"

# Trouver la target BoringSSL-GRPC
boring_ssl_target = project.targets.find { |t| t.name == 'BoringSSL-GRPC' }

if boring_ssl_target
  puts "Target BoringSSL-GRPC trouvée"
  
  # Modifier les configurations de build
  boring_ssl_target.build_configurations.each do |config|
    # Remplacer les flags problématiques
    if config.build_settings['OTHER_CFLAGS']
      config.build_settings['OTHER_CFLAGS'] = config.build_settings['OTHER_CFLAGS'].gsub(/-G\S*/, '-g')
      puts "OTHER_CFLAGS modifié pour #{config.name}"
    else
      config.build_settings['OTHER_CFLAGS'] = '$(inherited) -g'
      puts "OTHER_CFLAGS ajouté pour #{config.name}"
    end
    
    if config.build_settings['OTHER_CXXFLAGS']
      config.build_settings['OTHER_CXXFLAGS'] = config.build_settings['OTHER_CXXFLAGS'].gsub(/-G\S*/, '-g')
      puts "OTHER_CXXFLAGS modifié pour #{config.name}"
    else
      config.build_settings['OTHER_CXXFLAGS'] = '$(inherited) -g'
      puts "OTHER_CXXFLAGS ajouté pour #{config.name}"
    end
  end
  
  # Modifier les flags de compilation des fichiers
  boring_ssl_target.source_build_phase.files.each do |file|
    if file.settings && file.settings['COMPILER_FLAGS']
      orig_flags = file.settings['COMPILER_FLAGS']
      
      # Remplacer -GCC_WARN_INHIBIT_ALL_WARNINGS par -Wno-everything
      new_flags = orig_flags.gsub('-GCC_WARN_INHIBIT_ALL_WARNINGS', '-Wno-everything')
      
      # Remplacer toute option -G par -g
      new_flags = new_flags.gsub(/-G\S*/, '-g')
      
      if new_flags != orig_flags
        file.settings['COMPILER_FLAGS'] = new_flags
        puts "Flags modifiés pour un fichier"
      end
    end
  end
  
  puts "Sauvegarde du projet..."
  project.save
  puts "Projet sauvegardé avec succès"
else
  puts "Target BoringSSL-GRPC non trouvée!"
end
