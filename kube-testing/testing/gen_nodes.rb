require 'fileutils'

# Example usage:
# ruby gen_nodes.rb lets-encrypt-multi-ns/node2.yml 10 testcluster myprettyprettytest112233.openode.io=node###.nodetests.openode.io kuard2=kuard### quickstart-example-tls23=letsencrypt-prod-cert

if ARGV.length < 2
  puts "Usage: ruby gen_nodes.rb <model file> <nb nodes> <destination folder> replacement1=rep1...replacementN=toN"
  exit
end

model_file = ARGV[0]
nb_nodes = ARGV[1].to_i
destination_folder = ARGV[2]

FileUtils.mkdir_p destination_folder

model_content = File.read(model_file)

(1..nb_nodes).each do |i|
  content = model_content.clone

  (3..ARGV.length-1).each do |ii|
    parts = ARGV[ii].split("=")
    next if parts.length != 2

    parts[1].sub! "###", "#{i}"

    content.gsub! parts[0], parts[1]
  end

  file_output_path = "#{destination_folder}/node#{i}.yml"
  File.open(file_output_path, "w") { |file| file.write(content) }
  #puts "curr #{content}"
end
