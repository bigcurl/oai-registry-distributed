class ApiController < ApplicationController
  # This method returns all known repositories.
  #
  # Example:
  #
  # <repositories>
  #   <repository>
  #     <uuid>ljk23j-2l3k4-lkasd-oi234h</uuid>
  #     <url>http://repository.url</url>
  #     <state>scheduled_for_block_inclusion</state>
  #   </repository>
  #   <repository>
  #     <uuid>ncje8-oxjs7-yuenw-92jdz</uuid>
  #     <url>http://another.repository.url</url>
  #     <state>included_in_block_chain</state>
  #   </repository>
  # </repositories>
  def index
    repositories = Repository.all

    respond_to do |format|
      format.xml  { return render :xml => repositories, :status => 200}
    end
  end

  # This method returns information about a repository.
  # Takes a uuid as input argument
  #   <repository>
  #     <uuid>ljk23j-2l3k4-lkasd-oi234h</uuid>
  #     <url>http://repository.url</url>
  #     <state>scheduled_for_block_inclusion</state>
  #     <block>9e47ee39-818b-4647-83d1-19e5fb821062</block>
  #   </repository>
  def show
    repository = Repository.find_by_uuid params[:uuid]

    if !repository
      respond_to do |format|
        format.xml  { return render :xml => '', :status => 404}
      end
    end

    respond_to do |format|
      format.xml  { return render :xml => repository, :status => 200, only: [:uuid, :url] }
    end
  end

  # This method accepets a new repository url and queues it block inclusion
  def create
    repository = Repository.new
    repository.url = params[:repository][:url]

    respond_to do |format|
      if repository.save
        format.xml  { return render  :text => '', status: :created, location: repository.uuid }
      else
        format.xml  { return  render xml: repository.errors, status: :unprocessable_entity }
      end
    end
  end
end
