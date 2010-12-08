require 'rubygems'
require 'bundler'
Bundler.setup
# require 'sinatra'
# require 'addressable/uri'
# require 'rack-flash'
# require 'bitly'

helpers do
  include Rack::Utils
  alias_method :h, :escape_html
end

enable :sessions
use Rack::Flash

def input_vars(params)
  type = params[:type]
  {}.tap do |input|
    params.each do |(key, value)|
      if key =~ /^#{type}_(utm_(?:source|medium|campaign))$/
        input[$1] = value
      end
    end
  end
end

get '/' do
  erb :index
end

post '/tag' do
  begin
    url = Addressable::URI.parse(params[:url]).tap { |u| u.query_values = (u.query_values || {}).merge(input_vars(params)) }
    flash[:notice]   = "Your tagged URL is %s (or use the shortened version: %s)" % [url.to_s, Bitly.new('avdgaag', 'R_2a1f57d36ce47dc779c5facb7b67a978').shorten(url.to_s).short_url]
  rescue => e
    flash[:warning]  = e.message
  end
  redirect '/'
end

__END__
@@index
<!doctype html>
<html>
  <head>
    <meta charset="utf-8">
    <title>Link tagger</title>
  </head>
  <body>
    <% if flash.has?(:warning) %>
      <div id="flash" class="warning"><%= flash[:warning] %></div>
    <% end %>
    <% if flash.has?(:notice) %>
      <div id="flash" class="notice"><%= flash[:notice] %></div>
    <% end %>
    <h1>tag-a-link</h1>
    <p>Enter a URL below and tag it for tracking in Google Analytics. Choose a template or enter custom values.</p>
    <form action="/tag" method="post">
      <fieldset>
        <legend>URL</legend>
        <ol>
          <li>
            <label for="form_url">URL:</label>
            <input id="form_url" type="text" name="url" value="">
          </li>
        </ol>
      </fieldset>
      <fieldset>
        <legend><label><input type="radio" name="type" value="custom" checked> Custom Tags</label></legend>
        <ol>
          <li>
            <label for="form_utm_source">Source:</label>
            <input id="form_utm_source" type="text" name="custom_utm_source" value="" placeholder="Specific referrer">
          </li>
          <li>
            <label for="form_utm_medium">Medium:</label>
            <input id="form_utm_medium" type="text" name="custom_utm_medium" value="" placeholder="Kind of referrer">
          </li>
          <li>
            <label for="form_utm_campaign">Campaign:</label>
            <input id="form_utm_campaign" type="text" name="custom_utm_campaign" value="" placeholder="Campaign identifier">
          </li>
        </ol>
      </fieldset>
      <fieldset>
        <legend><label><input type="radio" name="type" value="social_media"> Social media</label></legend>
        <ol>
          <li>
            <label for="form_social_media_utm_source">Medium:</label>
            <input type="hidden" name="social_media_utm_medium" value="social_media">
            <select name="social_media_utm_source" id="form_social_media_utm_source">
              <option selected value="twitter">Twitter</option>
              <option value="linkedin">Linked In</option>
              <option value="Delicious">Delicious</option>
              <option value="facebook">Facebook</option>
              <option value="digg">Digg</option>
              <option value="myspace">MySpace</option>
              <option value="generic">generic</option>
            </select>
          </li>
          <li>
            <label for="form_subject">Subject:</label>
            <input type="text" id="form_social_media_subject" name="social_media_utm_campaign" value="" placeholder="Campaign identifier">
          </li>
        </ol>
      </fieldset>
      <fieldset>
        <legend><label><input type="radio" name="type" value="offline"> Offline</label></legend>
        <ol>
          <li>
            <label for="form_offline_utm_source">Medium:</label>
            <input type="hidden" name="offline_utm_medium" value="offline">
            <select name="offline_utm_source" id="form_offline_utm_source">
              <option selected value="print">Print</option>
              <option value="tv">TV</option>
              <option value="radio">Radio</option>
              <option value="generic">Generic</option>
            </select>
          </li>
          <li>
            <label for="form_offline_title">Campaign name:</label>
            <input type="text" id="form_offline_title" name="offline_utm_campaign" value="" placeholder="Campaign identifier">
          </li>
        </ol>
      </fieldset>
      <fieldset>
        <legend><label><input type="radio" name="type" value="newsletter"> Newsletter</label></legend>
        <ol>
          <li>
            <label for="form_newsletter_title">Title:</label>
            <input type="hidden" name="newsletter_utm_source" value="email">
            <input type="hidden" name="newsletter_utm_medium" value="newsletter">
            <input type="text" id="form_newsletter_title" name="newsletter_utm_campaign" value="" placeholder="Newsletter title">
          </li>
        </ol>
      </fieldset>
      <fieldset class="controls">
        <div><input type="submit" value="Tag link"></div>
      </fieldset>
    </form>
  </body>
</html>
