# coding : utf-8

require 'json'

class MapsController < ApplicationController
  @@servername = 'http://five-ring.herokuapp.com/'
  #@@servername = "http://localhost:3000"
  @@fileIDLength = 12
  WEEK_EXP = ["日", "月", "火", "水", "木", "金", "土"]
  MAPS_DATA_DIR = "data/maps"
  
  ID = "doidoi"
  PW = "doidoi"
  
  def auth_check(page)
    if session[:id].blank? or session[:id] != ID then
      render :action=> "auth_page", :param=> {page:page} and return
    end
    return
  end
  
  #管理画面トップ
  def admin_page
    auth_check("admin_page")
    @servername = @@servername
  end
  
  #表示画面
  def show
    @servername = @@servername
    @id = params[:id]
    
    filename = "#{MAPS_DATA_DIR}/#{@id}.json"
    
    #ファイルが存在しない場合の処理
    if File.exists?(filename) == false then
    	render :action => "error" and return
    end
    
    begin
	    file = File.open(filename, "r");
	    @json = file.gets.chomp
	    file.close
    rescue
    	render :action => "error" and return
    end
  end

  #登録画面
  def new
    auth_check("new")
    @servername = @@servername
  end
  
  #追加画面
  def add
    auth_check("add")
    @servername = @@servername
    @id = params[:id]
    
    filename = "#{MAPS_DATA_DIR}/#{@id}.json"
    
    #ファイルが存在しない場合の処理
    if File.exists?(filename) == false then
    	render :action => "error" and return
    end
    
    begin
	    file = File.open(filename, "r");
	    @json = file.gets.chomp
	    file.close
    rescue
    	render :action => "error" and return
    end
  end
  
  #登録処理
  def commit
    auth_check("admin_page")
    @servername = @@servername
    
    #パラメータ取得
    json = params[:data]
    title = params[:title]
    zoom = params[:zoom]
    center = params[:center]
    
    #ファイル保存
    fileID = params[:id] #パラメータでIDを指定されていれば、そのIDを使用
    if fileID == "" then
    	#指定されていなければ生成
	    fileID = rand(36**@@fileIDLength).to_s(36)
	end
    begin
    	filename = "#{MAPS_DATA_DIR}/#{fileID}.json"
	    newFile = File.open(filename, "w")
	    newFile.puts "{\"title\":\"#{title}\",\"center\":#{center},\"zoom\":#{zoom},\"data\":#{json}}"
	    newFile.close
	    
	    render :json => {url:@servername + "/client/show?id=" + fileID}
    rescue
    	render json => {url:"エラーが発生しました。"}
    end
  end
  
  #ファイル管理
  def management
    auth_check("management")
    @servername = @@servername
    
    begin
	    #保存したファイル一覧
	    files = Dir.entries(MAPS_DATA_DIR)
	    
	    #ファイル一覧の情報を取得
	    objs = []
	    files.each{ |file|
	    	extname = File.extname(file)
	    	fileID = file.gsub(extname, "")
	    	#JSON以外のファイルの場合、スキップ
	    	if extname != ".json" then
	    		next
	    	end
	    	
	    	filePath = "#{MAPS_DATA_DIR}/#{file}"
	    	mtime_date = File.mtime(filePath)
	    	weekNum = mtime_date.strftime("%w").to_i
	    	mdate = mtime_date.strftime("%Y-%m-%d（#{WEEK_EXP[weekNum]}）")
	    	mtime = mtime_date.strftime("%H:%M:%S")
	    	
	    	curFile = File.open(filePath, "r")
	    	json = JSON.parse(curFile.gets)
	    	obj = {"title"=>json["title"], "mdate"=>mdate, "mtime"=>mtime, "id"=>fileID, "length"=>json["data"].size()}
	    	objs.push(obj)
	    	curFile.close
	    }
	    
	    @jsonArray = JSON.generate(objs)
    rescue
    	render :action => "error"
    end
  end
  
  #ファイル削除
  def del
    auth_check("admin_page")
    if params[:id].blank? then
      render :action => "error"
    end
    fileID = params[:id]
    filepath = "#{MAPS_DATA_DIR}/#{fileID}.json"
    if File.exists?(filepath) then
      File.delete(filepath)
      render :json=> {result:"ok"} and return
    end
    render :json=> {result:"ng"} and return
  end
  
  #認証画面
  def auth_page
  end
  
  #認証処理
  def auth
    @servername = @@servername
    if params[:id] == ID and params[:pw] == PW then
      session[:id] = ID
      render :action=> "admin_page" and return
    end
    render :action=> "auth_page" and return
  end
  
  #エラー時の処理
  def error
  end
  
end
