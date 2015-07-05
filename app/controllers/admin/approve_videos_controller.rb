module Admin
  class ApproveVideosController < ApplicationController
    before_filter :require_login
    before_filter :is_admin?

    def new
      @videos = DecoratedCollection.new(
        Video.unapproved,
        CurriedDecorator.new(EmbeddableVideo, session)
      )
    end

    def create
      video = Video.find(params[:id])
      video.approve!
      redirect_to approve_videos_path
    end

    def destroy
      Video.find(params[:id]).destroy
      redirect_to approve_videos_path
    end

    private

    def is_admin?
      unless current_user.admin?
        flash.alert = "Page not found"
        redirect_to root_path
      end
    end
  end
end
