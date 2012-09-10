#!/usr/bin/env watchr
#!/usr/bin/env bundle exec watchr
# NOTE: not part of bundle yet - gem install watchr
#
# Script to watch files for changes and run specs
#    - attempts to use growlnotify via shell for status (mac os x)
#
# Usage:
#   ./script/watchr.rb
#

ENV["WATCHR"] = "1"
ENV["AUTOFEATURE"] = "1"
ENV["RSPEC"] = "1"

# icons used for growlnotify - all macs should have iChat right?
ICON_SUCCESS = "/Library/Application Support/Apple/iChat Icons/Gems/Emerald Round.gif"
ICON_FAILURE = "/Library/Application Support/Apple/iChat Icons/Gems/Ruby Square.gif"

system 'clear'

def strip_ansi(m)
  m.gsub(/\e\[[^m]*m/, '')
end


def growl(success, message)
  growlnotify = `which growlnotify`.chomp
  return if growlnotify.empty?   # bail if not found
  title = "Watchr Test Results"
  image = success ? ICON_SUCCESS : ICON_FAILURE
  options = "-n Watchr --image '#{File.expand_path(image)}' -m '#{strip_ansi(message)}' '#{title}'"
  system %( #{growlnotify} #{options} )
end

def run(cmd)
  puts("*** Running command: " + cmd)
  `#{cmd}`
end

#def ruby(*paths)
#  run "ruby #{gem_opt} -I.:lib:test -e'%w( #{paths.flatten.join(' ')} ).each {|p| require p }'"
#end

def rspec(*paths)
  run(%Q( bundle exec rspec --color --tty --format d  #{paths.flatten.join(' ')}  ))
end

def run_cucumber(*paths)
  run(%Q( bundle exec cucumber --profile watchr #{paths.flatten.join(' ')}  ))
end

def run_spec_files(*files)
  system('clear')
  result = rspec(files)
  last_lines = (result.split("\n"))[-2, 2].join("\n") rescue ""
  success = last_lines.include?('0 failures') ? true : false
  growl(success, last_lines)
  puts result
end

def run_cuke_files(*files)
  system('clear')
  result = run_cucumber(files)
  # get last lines of output ... scenarios, steps, time taken
  last_lines = (result.split("\n"))[-3, 3].join("\n") rescue "failed to get results"
  success = last_lines.include?('failed') ? false : true
  growl(success, last_lines)
  puts result
end

def run_all_specs
  run_spec_files("./spec")
end

def run_all_features
  run_cuke_files("./features")
end

# these are not necessarily based on model names right? feature names
# are something else ... hmm - maybe no way to determine which features
# to run when an app/**/*.rb file changes
def related_cuke_files(path)
  Dir['features/**/*.rb'].select { |file| file =~ /#{File.basename(path).split(".").first}.feature/ }
end

def related_spec_files(path)
  Dir['spec/**/*.rb'].select { |file| file =~ /#{File.basename(path).split(".").first}_spec.rb/ }
end


def run_suite
  run_all_specs
  run_all_features
end


########################################
########################################
#
# file matchers
#
watch('lib/.*/.*\.rb') { run_all_specs }
watch('lib/.*\.rb') { run_all_specs }
watch('config/.*/.*\.rb') { run_all_specs }
watch('config/.*\.rb') { run_all_specs }
watch('app/.*/.*\.rb') { |m| related_spec_files(m[0]).map {|tf| run_spec_files(tf) } }

watch('spec/.*/.*_spec\.rb') { |m| run_spec_files(m[0]) }
watch('spec/spec_helper\.rb') { run_all_specs }

# when a feature changes, run it.  when a support file changes, run all
watch('features/.*/.*\.feature') { |m| run_cuke_files(m[0]) }
watch('features/.*/.*\.rb') { run_all_features }

# Ctrl-\
Signal.trap 'QUIT' do
  puts " --- Running all tests ---\n\n"
  run_all_specs
end

@interrupted = false

# Ctrl-C
Signal.trap 'INT' do
  if @interrupted then
    @wants_to_quit = true
    abort("\n")
  else
    puts "Interrupt a second time to quit"
    @interrupted = true
    Kernel.sleep 1.5
    # raise Interrupt, nil # let the run loop catch it
    run_suite
  end
end
