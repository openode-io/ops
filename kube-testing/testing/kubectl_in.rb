
action = ARGV[0]
directory = ARGV[1]

Dir["#{directory}/*.yml"].each do |yaml|
  system("kubectl #{action} -f #{yaml}")
end