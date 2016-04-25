require "./lib/codebreaker_rack_app/rack_system"
use Rack::Static, :urls => ["/css", "/js"], :root => "lib/views"
run CodebreakerRackApp::RackSystem