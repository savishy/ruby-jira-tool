require 'rest-client'
require 'Base64'
require 'logger'
require 'json'

# references: https://www.krautcomputing.com/blog/
# 2015/06/21/how-to-use-basic-authentication-with-the-ruby-rest-client-gem/
# https://github.com/rest-client/rest-client

class Jira

  API_SUFFIX="/rest/api/latest"
  ISSUE_RESOURCE="/issue"
  PROJECT_RESOURCE="/project"
  attr_accessor :url
  
  ####
  # initialize Jira  
  ####
  def initialize(url, username, pwd)
    
    @logger = Logger.new(STDOUT)    
    @logger.info "hello"
    @url = url
    @u = username
    @p = pwd
    puts @url
    getProjects
  end
  
  
  def getProjects
    result = execute PROJECT_RESOURCE
    @logger.info("Projects: ")
    @logger.info result.length
    result.each do |r|
      @logger.info r["key"]
    end

  end
  
  #####
  # Execute resource and return response.
  #####
  def execute(resource)
    url.concat(API_SUFFIX)
    projectResource = @url.concat(resource)
    @logger.info "#{projectResource} #{@u} #{@p}"
    r = RestClient::Request.new(
        :method => :get,
        :url => projectResource,
        :user => @u, 
        :password => @p,
        :headers => { :accept => :json,
        :content_type => :json }
        )
    begin
      response = r.execute
      @logger.debug(response)
      results = JSON.parse(response.to_str)
      @logger.debug "#{projectResource}: #{results}"
      return results
    rescue RestClient::ExceptionWithResponse => err
      @logger.error "REST Exception #{err}"
    end
  end
end

