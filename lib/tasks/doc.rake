if Rails.env.development?
  require 'yard'

  # bring sexy back (sexy == tables)
  module YARD::Templates::Helpers::HtmlHelper
    def html_markup_markdown(text)
      markup_class(:markdown).new(text, :gh_blockcode, :fenced_code, :autolink, :tables).to_html
    end
  end

  YARD::Rake::YardocTask.new do |doc|
    doc.options << '-m' << 'markdown' << '-M' << 'redcarpet'
    doc.options << '--protected' << '--no-private'
    doc.options << '-r' << 'README.md'
    doc.options << '-o' << 'doc/app'
    doc.options << '--title' << "LogTenSafe Documentation'"

    doc.files = %w( app/**/*.rb lib/**/*.rb README.md )
  end
end
