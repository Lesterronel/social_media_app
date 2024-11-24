module ApplicationHelper
  def sortable(column, title = nil)
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
    link_to title, { sort: column, direction: direction, class: "sortable" }, data: { turbo_frame: "posts" }
  end
end
