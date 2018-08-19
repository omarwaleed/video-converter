require 'streamio-ffmpeg'

class VideoController < ApplicationController

  before_action :print_memory, :only => [:convert]

  def check
    movie = FFMPEG::Movie.new(params[:video].tempfile.path)
    render json: movie

    deleted = File.delete(params[:video].tempfile.path)
    puts "Deleted ", deleted
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

end
