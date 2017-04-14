module DontComment
  Offense = Struct.new(:loc, :path) do
    def relative_path
      pwd = Pathname.pwd
      absolute_path = pwd.join(path)
      absolute_path.relative_path_from(pwd)
    end
  end
end
