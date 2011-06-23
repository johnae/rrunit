module Rrunit

  class Service
    
    attr_reader :name
    attr_reader :command
    
    def initialize(command)
      @command = command
      @name = File.basename(command)
      @environment = Hash.new
      @exported_environment = Hash.new
      @args = Array.new
    end
    
    def args(*args)
      @args = args unless args.empty?
      args.empty? ? @args : self
    end
    
    def log_dir(log_dir=nil)
      @log_dir = log_dir unless log_dir.nil?
      log_dir.nil? ? @log_dir : self
    end
    
    def environment(env=nil)
      @environment=env if env.is_a?(Hash)
      env.nil? ? @environment : self
    end
    
    def exported_environment(env=nil)
      @exported_environment=env if env.is_a?(Hash)
      env.nil? ? @exported_environment : self
    end
    
    def env_var(value)
      case
      when value.is_a?(String)
        "\"#{value}\""
      else
        value.to_s
      end
    end
    
    def service
      sv = Array.new
      cmd = "exec #{command}"
      cmd << " #{@args.join(' ')}" unless @args.empty?
      sv << "#!/bin/bash"
      @exported_environment.each do |key, value|
        sv << "export #{key.to_s.upcase}=#{env_var(value)}"
      end
      @environment.each do |key, value|
        sv << "#{key.to_s.upcase}=#{env_var(value)}"
      end
      sv << cmd
      sv.join("\n")
    end
    
    def log_service
      if @log_dir
        sv = Array.new
        cmd = "exec svlogd -tt #{@log_dir}"
        sv << "#!/bin/bash"
        sv << cmd
        sv.join("\n")
      end
    end
    
    def write(path)
      @output_directory = path
      FileUtils.mkdir_p @output_directory
      File.open("#{@output_directory}/run", 'w') do |f|
        f << service
        f << "\n"
      end
      FileUtils.chmod 0755, "#{@output_directory}/run"
      if @log_dir
        FileUtils.mkdir_p "#{@output_directory}/log"
        File.open("#{@output_directory}/log/run", 'w') do |f|
          f << log_service
          f << "\n"
        end
        FileUtils.chmod 0755, "#{@output_directory}/log/run"
      end
    end
    
    def rm
      FileUtils.rm_r @output_directory
    end
    
  end
  
end