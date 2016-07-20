class TracksController < ApplicationController
  def index
  end
  
  def show
    @track = Track.find(params[:id])
  end
  
  def without_ilm
    @tracks = Track.all.where("ilm_id IS NULL")
    respond_to do |format|
      format.html { render :list }
      format.csv { render :list }
    end
  end
end
