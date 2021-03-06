rule /\#.*/ do |t|
  env = t.name.match(/\#.*/).to_s.gsub("#", "")
  ENV['MACK_ENV'] = env
  name = t.name.gsub("##{env}", "")
  Rake::Task[name].invoke
end

rule /^cachetastic:/ do |t|
  x = t.name.gsub("cachetastic:", '')
  x = x.split(":")
  cache_name = x.first
  cache_action = x.last
  puts "cache_name: #{cache_name}"
  puts "cache_action: #{cache_action}"
  ENV['cache_name'] = cache_name
  ENV['cache_action'] = cache_action
  Rake::Task["cachetastic:manipulate_caches"].invoke
end

rule /^generate:.+:desc/ do |t|
  klass = t.name.gsub("generate:", '')
  klass.gsub!(":desc", '')
  Rake::Task["environment"].invoke
  klass = "#{klass.camelcase}Generator"
  puts klass.constantize.describe
end

rule /^generate:/ do |t|
  klass = t.name.gsub("generate:", '')
  Rake::Task["environment"].invoke
  klass = "#{klass.camelcase}Generator"
  gen = klass.constantize.run(ENV.to_hash)
end

rule /^gems:freeze:/ do |t|
  gem_name = t.name.gsub('gems:freeze:', '')
  ENV['gem_name'] = gem_name
  Rake::Task["gems:install_and_freeze"].invoke
end

rule /^mack:portlet:unpack:/ do |t|
  key = t.name.gsub('mack:portlet:unpack:', '')
  ENV['unpacker_key'] = key
  Rake::Task["mack:portlet:unpacker"].invoke
end