require 'streamio-ffmpeg'

class VideoController < ApplicationController

  before_action :print_memory, :only => [:convert]

  def check
    movie = FFMPEG::Movie.new(params[:video].tempfile.path)
    puts '----------', valid_video_type?(movie.video_codec), movie.video_codec, '----------'
    render json: movie

    UploadFileCleanupJob.perform_later params[:video].tempfile.path
  end

  def convert

    movie = FFMPEG::Movie.new(params[:video].tempfile.path)

    
    if !valid_video_type?(movie.video_codec)
      puts "codec------------", movie.video_codec, movie.inspect
      return render status: 400, json: {
        error: "Invalid file format. Only mov, mp4, 3gp, flv, wmv, avi are allowed"
      }
    end
    
    if params[:target_format].blank?
      return render status: 400, json: {
        error: "Target format not provided"
      }
    elsif params[:target_format] != "mp4" && params[:target_format] != "flv"
      return render status: 400, json: {
        error: "Target format not allowed. Only mp4 and flv are allowed"
      }
    end

    converted_path = "/tmp/converted-"+Random.new_seed.to_s+"."+params[:target_format]
    converted = nil
    # begin
      conversion_thread = Thread.new {
        converted = movie.transcode(converted_path, {resolution: "320x240"}){ |progress| puts progress * 100 }
        puts converted.inspect
        puts "----------", converted.path, "---------"
        # puts "======= sent"
        # puts Thread.current.inspect
      }
      conversion_thread.join
      UploadFileCleanupJob.perform_later params[:video].tempfile.path
      # puts conversion_thread.status
      send_file(converted.path, filename: "Converted movie")
      # render json: {error: nil, message: "Converted"}
    # rescue => exception
    #   response status: 500
    # end

  end

  private

  def print_memory
    if block_given?
      yield
    end

    puts 'RAM USAGE: ' + `pmap #{Process.pid} | tail -1`[10,40].strip
  end

  def valid_video_type?(codec)
    ["mov", "mp4", "3gp", "flv", "wmv", "avi", "h264"].include?(codec)
  end

end
