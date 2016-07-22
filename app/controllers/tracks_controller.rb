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

  def without_occ
    @tracks = Track.all.where("occ_product_id IS NULL")
    respond_to do |format|
      format.html { render :list }
      format.csv { render :list }
    end
  end

  def without_tupac
    @tracks = Track.all.where("record_id IS NULL")
    respond_to do |format|
      format.html { render :list }
      format.csv { render :list }
    end
  end
end
