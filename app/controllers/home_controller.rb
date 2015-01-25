class HomeController < ApplicationController
  
  def follow
    @follow= Follow.create(:follower_id=>params[:follower_id], :following_id=>params[:following_id])
  end
  
  def unfollow
    @unfollow= Follow.destroy_all(:follower_id=>params[:follower_id], :following_id=>params[:following_id])
  end
  
  def homepage
    @statuses = Status.all.order('id desc')
  end

  def about
  end

  def dashboard
    # run a query of the users that I follow and call it peopleifollow
    @peopleifollow= Follow.where(:follower_id=>current_user.id)
    # from this query called peopleifollow, make me a list of the "following_id" value, call it ids_of_peopleifollow
    @ids_of_peopleifollow = @peopleifollow.collect { |f| f["following_id"] }
    # add the current_user's id to this list called ids_of_peopleifollow
    @ids_of_peopleifollow = @ids_of_peopleifollow.push(current_user.id)
    # now search for all the status updates of the users with the id in the list "ids_of_peopleifollow"
    @statuses = Status.where('user_id in (?)', @ids_of_peopleifollow).order('id desc')
  end

  def userlist
    @users= User.all
  end

  def profile
    @profile=User.find_by_username(params[:username])
  end

  def followers
    @profile = User.find_by_username(params[:username])
    @followers = Follow.where(:following_id=>@profile.id).joins("INNER JOIN USERS ON USERS.ID = FOLLOWS.FOLLOWER_ID")
  end
end
