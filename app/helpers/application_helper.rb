module ApplicationHelper
  include Pagy::Frontend
  
  def sortable(column, title = nil, params)
    # debugger if column == "user_name"
    title ||= column.titleize

    if column == "title"
      column = "name"
    elsif column == "user_name"
      column = "email"
    end
    # Determine the sorting direction
    direction = if column == params[:sort]
                 params[:direction] == "asc" ? "desc" : "asc"
               else
                 "asc"
               end

    # Generate the link
    link_to title, { sort: column, direction: direction, class: "sortable" }.merge!(params.permit!.reject {|p| ["direction","sort","class"].include?(p) }), data: { turbo_frame: "posts" }
  end
end
