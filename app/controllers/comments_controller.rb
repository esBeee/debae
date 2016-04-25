class CommentsController < ApplicationController

  before_action :authenticate_user!

  # POST /comments
  def create
    comment = current_user.comments.build(comment_params)

    # Comment can only be invalid if the body is blank
    # or exceeds 9999 characters. Either case will be
    # handeled by front-end validations.
    unless comment.save && comment.commentable
      Kazus.log(:info, "Tried to create a comment that is invalid", comment: comment, commentable: comment.commentable)
    end

    redirect_to comment.commentable
  end


  private

  def comment_params
    params.require(:comment).permit(:body, :commentable_id, :commentable_type)
  end
end
