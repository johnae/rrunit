require 'spec_helper'

module Rrunit
  describe Service do
    
    context "default settings" do
    
      let(:runit_service) { Service.new('service') }
      
      it "has a name" do
        runit_service.name.should == 'service'
      end
      
      it "has a basic runit run string" do
        runit_service.service.should == ["#!/bin/bash","exec #{runit_service.name}"].join("\n")
      end
      
    end
    
    context "with arguments" do
      
      let(:runit_service) { Service.new('service').args('-arg1', 1, '-arg2', 2) }
    
      it "has arguments for command" do
        runit_service.args.should == ['-arg1', 1, '-arg2', 2]
      end
      
      it "has a runit run string with arguments" do
        runit_service.service.should == ["#!/bin/bash","exec #{runit_service.name} -arg1 1 -arg2 2"].join("\n")
      end
      
    end
    
    context "with environment" do
      
      let(:runit_service) { 
        Service.new('service')
          .environment(variable1: "127.0.0.1", variable2: "www.google.com", variable3: 100)
          .exported_environment(evariable1: "exported")
      }
    
      it "has a runit run string with environment variables set" do
        runit_service.service.should == ["#!/bin/bash", "export EVARIABLE1=\"exported\"", "VARIABLE1=\"127.0.0.1\"", "VARIABLE2=\"www.google.com\"", "VARIABLE3=100", "exec #{runit_service.name}"].join("\n")
      end
      
    end
    
    context "with log_dir" do
      
      let(:runit_service) {
        Service.new('service')
          .args('-arg1', 1, '-arg2', 2)
          .log_dir('/tmp/somedir')
      }
      
      it "has a log_dir" do
        runit_service.log_dir.should == '/tmp/somedir'
      end
      
      it "has a log_service" do
        runit_service.log_service.should == ["#!/bin/bash","exec svlogd -tt #{runit_service.log_dir}"].join("\n")
      end
      
    end
    
    context "when writing the files" do
      
      let(:runit_output_directory) { "/tmp/runit_generator_spec_output_directory" }
      
      before do
        FileUtils.rm_rf(runit_output_directory)
        runit_service.write(runit_output_directory)
      end
      
      after(:all) do
        FileUtils.rm_rf(runit_output_directory)
      end
      
      context "without log dir" do
        
        let(:runit_service) { 
          Service.new('service')
            .args('-arg1', 1, '-arg2', 2)
            .exported_environment(var1: 100, var2: "HELLO")
        }
        
        it "writes the runit configuration files to specified location" do
          File.directory?(runit_output_directory).should be true
          File.exists?("#{runit_output_directory}/run").should be true
        end
        
        it "the runit run file should be executable" do
          File.stat("#{runit_output_directory}/run").executable?.should be true
        end
        
        it "the program run file should contain the service" do
          File.read("#{runit_output_directory}/run").should == runit_service.service+"\n"
        end
        
      end
      
      context "with log dir" do
        
        let(:runit_service) { 
          Service.new('service')
            .args('-arg1', 1, '-arg2', 2)
            .exported_environment(var1: 100, var2: "HELLO")
            .log_dir('/tmp/somedir')
        }
        
        it "writes the runit configuration files to specified location" do
          File.directory?(runit_output_directory).should be true
          File.exists?("#{runit_output_directory}/run").should be true
        end
        
        it "the runit run file should be executable" do
          File.stat("#{runit_output_directory}/run").executable?.should be true
        end
        
        it "the runit run file should contain the service" do
          File.read("#{runit_output_directory}/run").should == runit_service.service+"\n"
        end
        
        it "writes the runit log service to specified location" do
          File.directory?("#{runit_output_directory}/log").should be true
          File.exists?("#{runit_output_directory}/log/run").should be true
        end
        
        it "the runit log service run file should be executable" do
          File.stat("#{runit_output_directory}/log/run").executable?.should be true
        end
        
        it "the runit log service run file should contain the log service" do
          File.read("#{runit_output_directory}/log/run").should == runit_service.log_service+"\n"
        end
        
      end
    end
    
  end
end