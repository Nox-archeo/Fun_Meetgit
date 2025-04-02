#!/usr/bin/env ruby

# Ce script parcourt tous les fichiers de configuration Xcode dans le dossier Pods
# et remplace toutes les occurrences de l'option -G par -g

# Compte les modifications
changes_count = 0

# Fonction pour remplacer -G par -g dans un fichier
def replace_g_option_in_file(file_path)
  count = 0
  if File.exist?(file_path)
    puts "Examen de #{file_path}..."
    content = File.read(file_path)
    
    # Vérifier si le fichier contient l'option -G
    if content =~ /-G\S*/
      puts "Option -G trouvée dans #{file_path}, remplacement par -g"
      modified_content = content.gsub(/-G\S*/, '-g')
      File.write(file_path, modified_content)
      count = content.scan(/-G\S*/).length
      puts "#{count} remplacements effectués dans #{file_path}"
    end
  end
  return count
end

puts "Recherche des fichiers .pbxproj et .xcconfig dans Pods..."

# Chercher tous les fichiers pbxproj dans le dossier Pods
pbxproj_files = Dir.glob("Pods/**/*.pbxproj")
puts "Trouvé #{pbxproj_files.length} fichiers .pbxproj"

# Chercher également les fichiers xcconfig
xcconfig_files = Dir.glob("Pods/**/*.xcconfig")
puts "Trouvé #{xcconfig_files.length} fichiers .xcconfig"

# Traiter tous les fichiers pbxproj
pbxproj_files.each do |file|
  changes_count += replace_g_option_in_file(file)
end

# Traiter tous les fichiers xcconfig
xcconfig_files.each do |file|
  changes_count += replace_g_option_in_file(file)
end

puts "Script terminé. #{changes_count} options -G ont été remplacées par -g."
