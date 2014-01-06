function commonInit(){
	$(".contents").css("display","none");
	$(".foot.div").css("display","none");
	$("head").append('<link rel="shortcut icon" href="image/comp_logo.ico">');
		
	//ページトップのメニューバーに対するイベント処理
	$(".bar_button").hover(
		function(){
			$(this)
			.removeClass("bar_button").addClass("bar_button active");
		},
		function(){
			$(this)
			.removeClass("bar_button active").addClass("bar_button");
		})
		//メニューボタンの画面遷移
		.click(function(){
			var id = $(this).attr("id");
			switch (id) {
				case "home_button":
					movePage("index.html");
					break;
				case "comp_button":
					movePage("comp_property.html");
					break;
				case "service_button":
					movePage("service.html");
					break;
				case "owner_button":
					movePage("owner.html");
					break;
				case "contact_button":
					movePage("http://www.5-ring.com/#!contact_us/c13vo");
					break;
			}
		});
}

function initFrame(){
	//バーボタンの表示
	$("body").prepend($('<div></div>').addClass("controll bar"));
	$(".controll.bar").append($('<table></table>')
		.append($('<tr></tr>')
			.append('<td><div id="home_button" class="bar_button">ホーム</div></td>')
			.append('<td><div id="comp_button" class="bar_button">会社概要</div></td>')
			.append('<td><div id="service_button" class="bar_button">サービス</div></td>')
			.append('<td><div id="owner_button" class="bar_button">オーナー様へ</div></td>')
			.append('<td><div id="contact_button" class="bar_button">お問い合わせ</div></td>')
		)
	);
	
	//タイトルバーの表示
	$("body").prepend("<hr>");
	$("body").prepend($("<div></div>").addClass("title div"));
	$("body").prepend("<hr>");
	$(".title.div")
		.append("<table><tr><td><img src=\"image/comp_logo.jpg\" id=\"comp_logo\" width=\"40px\"></td><td>ファイブリング株式会社</td></tr></table>");
	
}

function movePage(url) {
	$(".contents").fadeOut("2000").queue(function() {
		location.href = url;
	});
}

function outPage(url) {
	$("body").fadeOut("2000").queue(function() {
		location.href = url;
	});
}
