ActiveAdmin.register Admin::Comment do

#
# W H I T E L I S T  M A N A G E M E N T
#
controller do
  def create
      params.permit!
    super
  end

  def update
    params.permit!
    super
  end

  def comment_params
      params.(:comment).permit( :id,
      	                        :body,
      	                        :utf8,
      	                        :authenticity_token,
      	                        :commit
      	                        )
    end
  end

end
