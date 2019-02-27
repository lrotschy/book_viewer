#
#
# require "sinatra"
# require "sinatra/reloader" if development?
# require "tilt/erubis"
#
# before do
#   @chapters = File.readlines("data/toc.txt")
# end
#
# helpers do
#   def paragrapher(string)
#     paras = []
#     string.split("\n\n").each_with_index do |p, idx|
#       paras << "<p id=paragraph#{idx}>#{p}</p>"
#     end
#     paras
#   end
#
#   def each_chapter
#     @chapters.each_with_index do |name, idx|
#       number = idx + 1
#       contents = File.read("data/chp#{number}.txt")
#       yield number, name, contents
#     end
#   end
#
#   def chapters_matching(query)
#     results = []
#     return results if !query || query.empty?
#     each_chapter do |number, name, contents|
#       matches = {}
#       contents.split("\n\n").each_with_index do |paragraph, index|
#         matches[index] = paragraph if paragraph.include?(query)
#       end
#       results << {number: number, name: name, paragraphs: matches} if matches.any?
#     end
#     results
#   end
#
# end
#
# get "/" do
#   @title = "The Adventures of Sherlock Homie"
#   erb :home
# end
#
# get "/chapters/:number" do
#   redirect "/" if params['number'].to_i > @chapters.size
#   @chapter = File.read("data/chp#{params['number']}.txt")
#   @title = @chapters[(params['number'].to_i - 1)]
#   erb :chapter
# end
#
# get "/show/:name" do
#   "#{params['name']}"
# end
#
# not_found do
#   redirect "/"
# end
#
# get "/search?:query?" do
#   @results = chapters_matching(params[:query])
#   erb :search2
# end
#


# my solution
require "sinatra"
require "sinatra/reloader"
require "tilt/erubis"

before do
  @chapters = File.readlines("data/toc.txt")
end

helpers do
  def paragrapher(string)
    paras = []
    string.split("\n\n").each_with_index do |p, idx|
      paras << "<p id=paragraph#{idx}>#{p}</p>"
    end
    paras
  end

  def search_text(str)
    hits = {}
    (1..12).each do |ch|
      contents = File.read("data/chp#{ch}.txt")
      paragrapher(contents).each_with_index do |para, idx|
        if para.downcase.include?(str.downcase)
          hits[ch] = {}
          hits[ch][idx] = para.gsub(str, "<strong>#{str}</strong>")
        end
      end
    end
    hits
  end

end

get "/" do
  @title = "The Adventures of Sherlock Homie"
  erb :home
end

get "/chapters/:number" do
  redirect "/" if params['number'].to_i > @chapters.size
  @chapter = File.read("data/chp#{params['number']}.txt")
  @title = @chapters[(params['number'].to_i - 1)]
  erb :chapter
end

get "/show/:name" do
  "#{params['name']}"
end

not_found do
  redirect "/"
end

get "/search?:query?" do
  @hits = []
  srch_str = params['query']
  @hits = search_text(srch_str) if params['query'] != nil
  erb :search
end
