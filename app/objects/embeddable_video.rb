class EmbeddableVideo < SimpleDelegator
  class Base
    def initialize(video)
      @video = video
    end

    protected

    attr_reader :video
  end

  class VimeoVideo < Base
    def url
      if video.url.match(/player/)
        video.url
      else
        video_id = URI.parse(video.url).path.gsub("/", "")
        "https://player.vimeo.com/video/#{video_id}"
      end
    end
  end

  class YouTubeVideo < Base
    def url
      video.url.sub("watch?v=", "embed/")
    end
  end

  class UnsupportedHost < RuntimeError; end

  CONFIG = {
    /vimeo/ => VimeoVideo,
    /youtube/ => YouTubeVideo,
  }

  def url
    host = URI.parse(__getobj__.url).host

    raise UnsupportedHost if host.nil?

    CONFIG.each do |regex, klass|
      return klass.new(__getobj__).url if host.match(regex)
    end

    raise UnsupportedHost
  end
end
