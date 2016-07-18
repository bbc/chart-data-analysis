class ChartsController < ApplicationController
  # GET /charts
  # GET /charts.json
  def index
    @charts = Chart.all
  end

  # GET /charts/1
  # GET /charts/1.json
  def show
    @chart = Chart.where(:date => params[:id]).
                   includes(:entries => [:track])
    @entries = ChartEntry.where(:chart => @chart)
  end

end
