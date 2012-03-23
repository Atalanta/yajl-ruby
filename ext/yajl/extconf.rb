require 'mkmf'
require 'rbconfig'

def not_gcc?
  (RbConfig::CONFIG['GCC'] != 'yes') and not (RbConfig::CONFIG['CC'].include?('gcc'))
end

def solaris?
  RbConfig::CONFIG['arch'].include?("sparc") or RbConfig::CONFIG['arch'].include?("solaris")
end

def gcc_override?
  ENV.key?("USE_GCC")
end

def use_solaris_studio_cflags?
  solaris? and not_gcc? and not gcc_override?
end

if use_solaris_studio_cflags?
  $CFLAGS << ' -xunroll=1' # Solaris studio requires a default; 1 means don't unroll loops.
else
  $CFLAGS << ' -Wall -funroll-loops'
  $CFLAGS << ' -Wextra -O0 -ggdb3' if ENV['DEBUG']
end

create_makefile('yajl/yajl')
