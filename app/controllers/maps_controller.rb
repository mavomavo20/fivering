# coding : utf-8

require 'json'

class MapsController < ApplicationController
  @@servername = 'http://fivering.herokuapp.com/'
  #@@servername = "http://localhost:3000"
  @@fileIDLength = 12
  WEEK_EXP = ["日", "月", "火", "水", "木", "金", "土"]
  
  #管理画面トップ
  def admin_page
    @servername = @@servername
  end
  
  #表示画面
  def show
    @servername = @@servername
    @id = params[:id]
    
    filename = "data/#{@id}.json"
    
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
    @servername = @@servername
  end
  
  #登録処理
  def commit
    @servername = @@servername
    
    #パラメータ取得
    json = params[:data]
    title = params[:title]
    zoom = params[:zoom]
    center = params[:center]
    
    #ファイル保存
    fileID = rand(36**@@fileIDLength).to_s(36)
    begin
	    newFile = File.open("data/" + fileID + ".json", "w")
	    newFile.puts "{\"title\":\"#{title}\",\"center\":#{center},\"zoom\":#{zoom},\"data\":#{json}}"
	    newFile.close
	    
	    render :json => {url:@servername + "/maps/show?id=" + fileID}
    rescue
    	render json => {url:"エラーが発生しました。"}
    end
  end
  
  #ファイル管理
  def management
    @servername = @@servername
    
    begin
	    #保存したファイル一覧
	    files = Dir.entries("data/")
	    
	    #ファイル一覧の情報を取得
	    objs = []
	    files.each{ |file|
	    	extname = File.extname(file)
	    	fileID = file.gsub(extname, "")
	    	#JSON以外のファイルの場合、スキップ
	    	if extname != ".json" then
	    		next
	    	end
	    	
	    	filePath = "data/" + file
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
    fileID = params[:id]
    filepath = "data/" + fileID + ".json"
    if File.exists?(filepath) then
      File.delete(filepath)
      render :json=> {result:"ok"} and return
    end
    render :json=> {result:"ng"} and return
  end
  
  #エラー時の処理
  def error
  end
  
end
