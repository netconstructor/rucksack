class ListItemsController < ApplicationController
  before_filter :grab_page
  before_filter :login_required
  before_filter :grab_list
  
  # GET /list_items
  # GET /list_items.xml
  def index
    @list_items = ListItem.find(:all)

    respond_to do |format|
      format.html # index.html.erb
      format.xml  { render :xml => @list_items }
    end
  end

  # GET /list_items/1
  # GET /list_items/1.xml
  def show
    @list_item = ListItem.find(params[:id])

    respond_to do |format|
      format.html # show.html.erb
      format.xml  { render :xml => @list_item }
    end
  end

  # GET /list_items/new
  # GET /list_items/new.xml
  def new
    @list_item = ListItem.new

    respond_to do |format|
      format.html # new.html.erb
      format.xml  { render :xml => @list_item }
    end
  end

  # GET /list_items/1/edit
  def edit
    @list_item = ListItem.find(params[:id])
  end

  # POST /list_items
  # POST /list_items.xml
  def create
    @list_item = ListItem.new(params[:list_item])
    @list_item.list = @list
    @list_item.created_by = @logged_user

    respond_to do |format|
      if @list_item.save
        flash[:notice] = 'ListItem was successfully created.'
        format.html { redirect_to(@list_item) }
        format.js
        format.xml  { render :xml => @list_item, :status => :created, :location => @list_item }
      else
        format.html { render :action => "new" }
        format.js
        format.xml  { render :xml => @list_item.errors, :status => :unprocessable_entity }
      end
    end
  end

  # PUT /list_items/1
  # PUT /list_items/1.xml
  def update
    @list_item = ListItem.find(params[:id])

    respond_to do |format|
      if @list_item.update_attributes(params[:list_item])
        flash[:notice] = 'ListItem was successfully updated.'
        format.html { redirect_to(@list_item) }
        format.js
        format.xml  { head :ok }
      else
        format.html { render :action => "edit" }
        format.js
        format.xml  { render :xml => @list_item.errors, :status => :unprocessable_entity }
      end
    end
  end

  # DELETE /list_items/1
  # DELETE /list_items/1.xml
  def destroy
    @list_item = ListItem.find(params[:id])
    @list_item.destroy

    respond_to do |format|
      format.html { redirect_to(list_items_url) }
        format.js
      format.xml  { head :ok }
    end
  end
  
  # PUT /list_items/1
  def status
    @list_item = ListItem.find(params[:id])
    @list_item.set_completed(params[:list_item][:completed] == 'true', @logged_user)
    @list_item.save

    respond_to do |format|
      format.html { redirect_to(list_items_url) }
      format.js
      format.xml  { head :ok }
    end

  end

protected

  def grab_list
    begin
        @list = List.find(params[:list_id])
    rescue ActiveRecord::RecordNotFound
        error_status(true, :error_cannot_find_list)
        return false
    end
    
    true
  end
end
