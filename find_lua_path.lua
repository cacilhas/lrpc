for path in package.path:gmatch "[^;]+" do
  if path:match "/share/lua/" then
    path = path:gsub("^(.+)/[^/]*$", "%1")
    if path:match "?$" then
      path = path:sub(0, #path - 1)
    end
    io.write(path)
    break
  end
end
