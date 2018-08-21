require 'streamio-ffmpeg'

class VideoController < ApplicationController

  before_action :print_memory, :only => [:convert]

  def check
    movie = FFMPEG::Movie.new(params[:video].tempfile.path)
    puts '----------'
    puts valid_video_type?(movie.video_codec)
    puts movie.video_codec
    puts '----------'
    render json: movie

    UploadFileCleanupJob.perform_later params[:video].tempfile.path
  end

  def convert

    puts request
    print_memory{puts 'In convert route'}

    render json: params[:video]

  end

  private

  def print_memory
    if block_given?
      yield
    end

    puts 'RAM USAGE: ' + `pmap #{Process.pid} | tail -1`[10,40].strip
  end

  def valid_video_type?(codec)
    !!(codec == "mov" || codec == "mp4" || codec == "3gp" || codec == "flv" || codec == "wmv" || codec == "avi")
  end

end
