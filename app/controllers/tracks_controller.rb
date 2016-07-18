class TracksController < ApplicationController
  def index
  end
  
  def show
    @track = Track.find(params[:id])
  end
  
  def without_ilm
    @tracks = Track.all.where("ilm_id IS NULL")
    render :list
  end
end
