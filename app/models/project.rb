# app/models/project.rb
class Project < ApplicationRecord
  # Existing code...

  # Add a has_many relationship for reviews
  has_many :reviews, dependent: :destroy

  # Add a method to calculate the average rating
  def average_rating
    reviews.average(:rating)
  end

  # Add a method to calculate the total number of reviews
  def total_reviews
    reviews.count
  end
end

# app/models/review.rb
class Review < ApplicationRecord
  belongs_to :project
  belongs_to :user

  validates :rating, presence: true, numericality: { only_integer: true, greater_than_or_equal_to: 1, less_than_or_equal_to: 5 }
  validates :comment, presence: true

  # Add a method to display the rating as a string
  def rating_string
    "#{rating} out of 5"
  end
end

# app/controllers/reviews_controller.rb
class ReviewsController < ApplicationController
  before_action :set_project

  def create
    @review = @project.reviews.new(review_params)
    @review.user = current_user

    if @review.save
      redirect_to @project, notice: 'Review was successfully created.'
    else
      render template: 'projects/show'
    end
  end

  def destroy
    @review = Review.find(params[:id])
    @review.destroy
    redirect_to @review.project, notice: 'Review was successfully destroyed.'
  end

  private

  def set_project
    @project = Project.find(params[:project_id])
  end

  def review_params
    params.require(:review).permit(:rating, :comment)
  end
end

# app/views/projects/show.html.erb
<h1><%= @project.name %></h1>

<!-- Display the average rating and total number of reviews -->
<p>Rating: <%= @project.average_rating %> ( <%= @project.total_reviews %> reviews )</p>

<!-- Display all reviews for the project -->
<h2>Reviews:</h2>
<ul>
  <% @project.reviews.each do |review| %>
    <li>
      <%= review.rating_string %>
      <%= review.comment %>
      <% if review.user == current_user %>
        <%= link_to 'Delete', [review.project, review], method: :delete, data: { confirm: 'Are you sure?' } %>
      <% end %>
    </li>
  <% end %>
</ul>

<!-- Form to create a new review -->
<h2>Leave a Review:</h2>
<%= render partial: 'reviews/form', locals: { project: @project } %>

# app/views/reviews/_form.html.erb
<%= form_for([project, Review.new], url: { controller: 'reviews', action: 'create' }) do |form| %>
  <%= form.label :rating %>
  <%= form.number_field :rating %>

  <%= form.label :comment %>
  <%= form.text_area :comment %>

  <%= form.submit %>
<% end %>