module Shift
  class ShiftFolder
    def initialize(folder_name = "shift", shiftfile_name = "Shiftfile")
      @folder_name = folder_name
      @shiftfile_name = shiftfile_name
    end

    # Path to the fastlane folder containing the Fastfile and other configuration files
    def path
      value ||= "./#{@folder_name}/" if File.directory?("./#{@folder_name}/")
      value ||= "./.#{@folder_name}/" if File.directory?("./.#{@folder_name}/") # hidden folder
      value ||= "./" if File.basename(Dir.getwd) == @folder_name && File.exist?(@shiftfile_name) # inside the folder
      value ||= "./" if File.basename(Dir.getwd) == ".#{@folder_name}" && File.exist?(@shiftfile_name) # inside the folder and hidden
      value ||= @folder_name if File.directory?(@folder_name)
      return value
    end

    def shiftfile_path
      return nil if self.path.nil?

      path = File.join(self.path, @shiftfile_name)
      return path if File.exist?(path)
      return nil
    end
  end
end