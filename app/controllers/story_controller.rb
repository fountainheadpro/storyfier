class StoryController < ApplicationController

  before_filter :authenticate_user!



  def index

  end

  def show
    @story=JSON.parse(open(Rails.root.join('public','stories', "#{params[:id]}.json")) { |f| f.read })
  end



end
