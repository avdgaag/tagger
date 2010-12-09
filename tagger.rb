require 'bundler/setup'
require 'sinatra'
require 'addressable/uri'
require 'rack-flash'
require 'bitly'

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
<!DOCTYPE html>
<html>
  <head>
    <meta charset="utf-8">
    <title>Link tagger</title>
    <style type="text/css" media="screen">
        * {
            margin: 0;
            padding: 0;
            list-style: none;
            text-decoration: none;
        }
        html {
            border: 10px solid #eee;
            position: absolute;
            top: 0;
            left: 0;
            right: 0;
            bottom: 0;
            margin: 0;
            padding: 0;
        }
        @-webkit-keyframes pop {
            from {
                opacity: 0;
            }
            to {
                opacity: 1;
            }
        }
        body {
            font: 12px/20px Arial, sans-serif;
            color: #555;
            width: 500px;
            margin: 0 auto;
            text-align: left;
            -webkit-animation-name: pop;
            -webkit-animation-duration: .5s;
            -webkit-animation-iteration-count: 1;
            -webkit-animation-timing-function: ease-in;
        }
        p, form, h1, #flash {
            margin: 20px 0;
        }
        #flash {
            border: 1px solid;
            padding: 9px;
            border-radius: 3px;
            -webkit-box-shadow: 1px 1px 1px rgba(0,0,0,.33);
            text-shadow: -1px -1px 1px rgba(255,255,255,.33);
            margin: 20px -10px;
            display: none;
        }
        #flash.warning {
            background-color: #fad4d4;
            color: #900;
            border-color: #900;
        }
        #flash.notice {
            background-color: #d4fad4;
            color: #090;
            border-color: #090;
        }
        h1 {
            text-transform: uppercase;
            letter-spacing: 1px;
            border-bottom: 1px solid #dedede;
            font-size: 20px;
            margin-bottom: -10px;
            line-height: 30px;
        }
        fieldset {
            background: #fff;
            border: 1px solid #eee;
            position: relative;
            padding: 30px 10px 10px 10px;
            margin: 10px 0;
            border-radius: 3px;
        }
        form fieldset:first-child legend {
            display: none;
        }
        form fieldset:first-child, form fieldset:last-child {
            padding: 9px;
        }
        legend {
            position: absolute;
            font-weight: bold;
            top: 10px;
        }
        ol {
            padding: 0;
            margin: 0;
            list-style: none;
        }
        li {
            clear: left;
            display: block;
            margin: 10px 0;
        }
        li label {
            float: left;
            width: 100px;
            margin-right: 20px;
            padding: 2px 0;
        }
        li input {
            font-size: 16px;
            padding: 2px;
            width: 345px;
        }
        legend select {
            margin-left: 25px;
        }
        form {
            background: #f9f9f9;
            margin: 20px -10px;
            padding: 0 10px;
            border: 1px solid #eee;
            border-radius: 3px;
        }
        a {
            color: #000;
            text-decoration: underline;
            -webkit-transition: all .25s linear;
        }
        a:visited {
            color: #555;
        }
        a:hover, a:focus {
            color: #009;
        }
        a:active {
            position: relative;
            top: 1px;
            left: 1px;
        }
        abbr {
            font-size: 85%;
            text-transform: uppercase;
            letter-spacing: 1px;
            cursor: help;
        }
        fieldset.controls div {
            display: inline-block;
            vertical-align: top;
        }
        div.spinner {
          position: relative;
          width: 24px;
          margin-left: 12px;
          height: 24px;
          display: inline-block;
        }

        div.spinner div {
          width: 12%;
          height: 26%;
          background: #000;
          position: absolute;
          left: 44.5%;
          top: 37%;
          opacity: 0;
          -webkit-animation: fade 1s linear infinite;
          -webkit-border-radius: 50px;
          -webkit-box-shadow: 0 0 3px rgba(0,0,0,0.2);
        }

        div.spinner div.bar1 {-webkit-transform:rotate(0deg) translate(0, -142%); -webkit-animation-delay: 0s;}
        div.spinner div.bar2 {-webkit-transform:rotate(30deg) translate(0, -142%); -webkit-animation-delay: -0.9167s;}
        div.spinner div.bar3 {-webkit-transform:rotate(60deg) translate(0, -142%); -webkit-animation-delay: -0.833s;}
        div.spinner div.bar4 {-webkit-transform:rotate(90deg) translate(0, -142%); -webkit-animation-delay: -0.75s;}
        div.spinner div.bar5 {-webkit-transform:rotate(120deg) translate(0, -142%); -webkit-animation-delay: -0.667s;}
        div.spinner div.bar6 {-webkit-transform:rotate(150deg) translate(0, -142%); -webkit-animation-delay: -0.5833s;}
        div.spinner div.bar7 {-webkit-transform:rotate(180deg) translate(0, -142%); -webkit-animation-delay: -0.5s;}
        div.spinner div.bar8 {-webkit-transform:rotate(210deg) translate(0, -142%); -webkit-animation-delay: -0.41667s;}
        div.spinner div.bar9 {-webkit-transform:rotate(240deg) translate(0, -142%); -webkit-animation-delay: -0.333s;}
        div.spinner div.bar10 {-webkit-transform:rotate(270deg) translate(0, -142%); -webkit-animation-delay: -0.25s;}
        div.spinner div.bar11 {-webkit-transform:rotate(300deg) translate(0, -142%); -webkit-animation-delay: -0.1667s;}
        div.spinner div.bar12 {-webkit-transform:rotate(330deg) translate(0, -142%); -webkit-animation-delay: -0.0833s;}

         @-webkit-keyframes fade {
          from {opacity: 1;}
          to {opacity: 0.25;}
        }
    </style>
  </head>
  <body>
    <% if flash.has?(:warning) %>
      <div id="flash" class="warning"><%= flash[:warning] %></div>
    <% end %>
    <% if flash.has?(:notice) %>
      <div id="flash" class="notice"><%= flash[:notice] %></div>
    <% end %>
    <h1>tag–a–link</h1>
    <p>Enter a <abbr title="Uniform Resource Locator">URL</abbr> below and tag it for tracking in <a href="http://www.google.com/analytics/" rel="external">Google Analytics</a> — either by choosing a template or entering custom values. Press “Tag this link” and we’ll give you a <strong>tagged</strong> <em>and</em> a <strong>shortened</strong> <abbr>URL</abbr>.</p>
    <form action="/tag" method="post">
      <fieldset>
        <legend>URL</legend>
        <ol>
          <li>
            <label for="form_url"><abbr>URL</abbr> to tag:</label>
            <input id="form_url" type="text" name="url" value="" placeholder="http://example.com">
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
            <label for="form_social_media_utm_source">Referrer:</label>
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
            <label for="form_subject">Campaign title:</label>
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
            <label for="form_offline_title">Campaign title:</label>
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
        <div><input type="submit" value="Tag this link &rsaquo;"></div>
      </fieldset>
    </form>
    <script>
        var fieldsets = Array.prototype.slice.call(document.getElementsByTagName('fieldset')),
            first     = fieldsets.shift(),
            last      = fieldsets.pop(),
            fragment  = document.createDocumentFragment(),
            fieldset  = document.createElement('fieldset'),
            legend    = document.createElement('legend'),
            select    = document.createElement('select'),
            i         = fieldsets.length,
            dict      = {};
        while(i--) {
            var f      = fieldsets[i],
                option = document.createElement('option'),
                leg    = f.getElementsByTagName('legend')[0],
                label  = leg.getElementsByTagName('label')[0].lastChild.nodeValue.replace(/^ /, ''),
                list   = f.getElementsByTagName('ol')[0];
            dict[label] = list;
            option.appendChild(document.createTextNode(label));
            option.setAttribute('value', label);
            list.style.display = 'none';
            select.appendChild(option);
            fieldset.appendChild(list);
            f.parentNode.removeChild(f);
        }
        list.style.display = 'block';
        select.value = label;
        select.addEventListener('change', function(e) {
            for(l in dict) if(dict.hasOwnProperty(l)) dict[l].style.display = 'none';
            dict[this.value].style.display = 'block';
        });
        legend.appendChild(document.createTextNode('Pick a template: '))
        legend.appendChild(select);
        fieldset.insertBefore(legend, fieldset.firstChild);
        fragment.appendChild(fieldset);
        last.parentNode.insertBefore(fragment, last);
        document.forms[0].addEventListener('submit', function() {
          var spinner = document.createElement('div');
          spinner.setAttribute('class', 'spinner');
          for(var i = 1; i <= 12; i++) {
            var d = document.createElement('div');
            d.setAttribute('class', 'bar' + i);
            spinner.appendChild(d);
          }
          last.getElementsByTagName('input')[0].disabled = true;
          last.appendChild(spinner);
        });
    </script>
  </body>
</html>
