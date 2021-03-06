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
                   includes(:entries => [:track]).first
    @entries = ChartEntry.where(:chart => @chart)
  end

  def random
    @chart = Chart.all.order('RANDOM()').first
    redirect_to @chart
  end

end
