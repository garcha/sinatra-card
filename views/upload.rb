<form action="/" method="post" enctype="multipart/form-data"></div>
      <input type="file" name="image" />
      <input type="submit" name="submit" value="Upload" />
</form>
    <% @uploads.each do |upload| %>
      <img src="<%= upload.file.url %>" />
    <% end %>
