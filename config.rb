page '/*.xml', layout: false
page '/*.json', layout: false
page '/*.txt', layout: false

set :url_root, ENV.fetch('BASE_URL')

ignore '/templates/*'

activate :i18n, langs: [:it], mount_at_root: false
activate :asset_hash
activate :directory_indexes
activate :pagination
activate :inline_svg
activate :dato, token: ENV.fetch('DATO_API_TOKEN'), live_reload: false

activate :external_pipeline,
  name: :webpack,
  command: build? ?
    "./node_modules/webpack/bin/webpack.js --bail -p" :
    "./node_modules/webpack/bin/webpack.js --watch -d --progress --color",
  source: ".tmp/dist",
  latency: 1

configure :build do
  activate :minify_html do |html|
    html.remove_input_attributes = false
  end
  activate :search_engine_sitemap,
    default_priority: 0.5,
    default_change_frequency: 'weekly'
end

configure :development do
  activate :livereload
end

helpers do
  def active_link_to(name, url, options = {})
    if (url === "/#{I18n.locale}/" && current_page.url === "/#{I18n.locale}/") ||
      (url != "/#{I18n.locale}/" && current_page.url[0...-1].eql?(url))
      options[:class] = options.fetch(:class, '') + " is-active"
      link_to name, url, options
    else
      link_to name, url, options
    end
  end

  def icon(name)
    content_tag(:svg) do
      content_tag(:use, "", "xlink:href" => "##{name}")
    end
  end
end

proxy "/_redirects",
  "/templates/redirects.txt"

dato.tap do |dato|
  proxy "/index.html",
    "/templates/homepage.html",
    locals: {page: dato.homepage}

  proxy "/#{dato.recap_page.slug}/index.html",
    "/templates/recap.html",
    locals: {page: dato.recap_page}

  proxy "/#{dato.personas_page.slug}/index.html",
    "/templates/personas.html",
    locals: {page: dato.personas_page}

  proxy "/#{dato.hypothesis_page.slug}/index.html",
    "/templates/hypothesis_index.html",
    locals: {page: dato.hypothesis_page}

  dato.protopersonas.each do |pp|
    proxy "/#{dato.personas_page.slug}/#{pp.slug}/index.html",
      '/templates/proto-persona.html',
      locals: { pp: pp }
  end

  dato.hypotesies.each do |hyp|
    proxy "/#{dato.hypothesis_page.slug}/#{hyp.slug}/index.html",
      '/templates/hypothesis.html',
      locals: { hyp: hyp }
  end
end
