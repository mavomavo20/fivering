# coding : utf-8

require 'json'
require 'pg'
require 'date'

class MapsController < ApplicationController
  @@servername = 'http://five-ring.herokuapp.com/'
  @@fileIDLength = 12
  WEEK_EXP = ["日", "月", "火", "水", "木", "金", "土"]
  MAPS_DATA_DIR = "data/maps"
  ID = "doidoi"
  PW = "doidoi"
  
  connection_strs = {host:"localhost", user:"user", password:"user", dbname:"develop", port:5432}
  
  #コンストラクタ
  def initialize()
    super
    
  	case ENV['RAILS_ENV']
  	when "development"
    	@@servername = "http://localhost:3000"
  	when "production"
    	@@servername = 'http://five-ring.herokuapp.com/'
  	when "test"
    	@@servername = "http://localhost:3000"
    end
  end
  
  def select_prop
  	connection = PG::connect(:host => "localhost", :user => "postgres", :password => "postgres ユーザのパスワード", :dbname => "スキーマの名前", :port => "ポート番号")
  end
  
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
    
    jsonFiles = JsonFile.where("name = '#{@id}'")
    
    #ファイルが存在しない場合の処理
    if jsonFiles.length == 0 then
    	render :action => "error" and return
    end
    
    begin
	    record = jsonFiles[0]
	    @json = record.json
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
    
    jsonFiles = JsonFile.where("name = '#{@id}'")
    #ファイルが存在しない場合の処理
    if jsonFiles.length == 0 then
    	render :action => "error" and return
    end
    
    begin
	    record = jsonFiles[0]
	    @json = record.json
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
    if fileID.blank? == true then
    	#指定されていなければ生成
	    fileID = rand(36**@@fileIDLength).to_s(36)
	else
	    jsonFiles = JsonFile.where("name = '#{fileID}'")
	    #ファイルが存在する場合の処理
	    if jsonFiles.length >= 1 then
	    	JsonFile.delete_all("name = '#{fileID}'")
	    end
    end
	
    begin
	    name = fileID
	    updated = DateTime.now
	    json = "{\"title\":\"#{title}\",\"center\":#{center},\"zoom\":#{zoom},\"data\":#{json}}"
	    
	    jsonFile = JsonFile.create(:name=>name, :updated=>updated, :json=>json)
	    
	    render :json => {url:@servername + "/client/show?id=" + fileID} and return
    rescue => ex
    	render json => {url:"エラーが発生しました。"} and return
    end
  end
  
  #ファイル管理
  def management
    auth_check("management")
    @servername = @@servername
    
    begin
	    #保存したファイル一覧
	    records = JsonFile.all
	    
	    #ファイル一覧の情報を取得
	    objs = []
	    records.each{ |record|
	    	
	    	mtime_date = record.updated
	    	weekNum = mtime_date.strftime("%w").to_i
	    	mdate = mtime_date.strftime("%Y-%m-%d（#{WEEK_EXP[weekNum]}）")
	    	mtime = mtime_date.strftime("%H:%M:%S")
	    	
	    	json = JSON.parse(record.json)
	    	obj = {"title"=>json["title"], "mdate"=>mdate, "mtime"=>mtime, "id"=>record.name, "length"=>json["data"].size()}
	    	objs.push(obj)
	    }
	    
	    @jsonArray = JSON.generate(objs)
    rescue => ex
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

    jsonFiles = JsonFile.where("name = '#{fileID}'")
    #ファイルが存在しない場合の処理
    if jsonFiles.length < 1 then
    	render :json=> {result:"ng"} and return
    end
    
    JsonFile.delete_all("name = '#{fileID}'")
    render :json=> {result:"ok"} and return
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
